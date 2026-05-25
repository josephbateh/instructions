# Jellyfin Docker Setup

[Jellyfin](https://jellyfin.org/) is a free, self-hosted media server — a Plex/Emby alternative for streaming your own
movies, TV, and music to web, mobile, and TV clients.

This stack runs Jellyfin with **Intel iGPU hardware transcoding** enabled and a backup sidecar that takes **automated
nightly snapshots of the Jellyfin config directory** (users, library metadata, watch history, plugins, settings).

## What's in the stack

| Container                | Purpose                                                                      |
| ------------------------ | ---------------------------------------------------------------------------- |
| `jellyfin`               | Media server. Exposes port 8096 (HTTP), 8920 (HTTPS), 7359/UDP, 1900/UDP.    |
| `jellyfin_config_backup` | Rotated daily tarball of `/config`. Briefly stops Jellyfin for a clean dump. |

## Setup

### 1. Copy the env file and edit it

```shell
cp .env.example .env
$EDITOR .env
```

At minimum set:

- `PUID` / `PGID` — run `id` on the host and copy your user's IDs.
- `RENDER_GID` — see [Hardware acceleration](#hardware-acceleration-intel-qsv--va-api) below.
- `CONFIG_LOCATION`, `CACHE_LOCATION`, `MEDIA_LOCATION` — where Jellyfin reads and writes on the host.
- `BACKUP_LOCATION` — point at a different disk or mount than `CONFIG_LOCATION`.

### 2. Create the host directories

```shell
mkdir -p /home/joseph/jellyfin/config /home/joseph/jellyfin/cache
mkdir -p /mnt/backups/jellyfin
# Media directory probably already exists; create if not.
mkdir -p /home/joseph/media
```

### 3. Start the stack

```shell
docker compose up -d
```

Open [http://localhost:8096](http://localhost:8096), walk through the first-run wizard (create admin user, add your
media libraries pointing at `/media/...`), and you're done.

## Hardware acceleration (Intel QSV / VA-API)

Intel integrated graphics from Gen 7 (Ivy Bridge, 2012) onward support Quick Sync Video. Jellyfin can offload
H.264/HEVC/AV1 decode and encode to the iGPU, which drops a typical 1080p transcode from ~80% CPU on one core to a few
percent — and enables tone-mapped 4K HDR transcodes that are impractical on CPU alone.

### Verify your host has an iGPU

```shell
ls /dev/dri
# Expect: card0  renderD128  (renderD128 is the one Jellyfin uses)
```

If `/dev/dri/renderD128` doesn't exist you either don't have an Intel/AMD GPU, the i915 kernel module isn't loaded, or
you're inside a VM without GPU passthrough. Install `intel-gpu-tools` and run `intel_gpu_top` on the host to confirm the
iGPU is alive.

### Find your host's render group GID

The container user needs to be in the same group that owns `/dev/dri/renderD128`:

```shell
getent group render | cut -d: -f3
```

Put that number into `RENDER_GID` in `.env`. Common values: Ubuntu/Debian `989` or `993`, Arch `998`, Fedora `105`.
Restart the stack after changing it.

### Enable it in Jellyfin

1. Open the web UI → **Dashboard** → **Playback** → **Transcoding**.
2. Set **Hardware acceleration** to **Intel QuickSync (QSV)** (preferred on modern Intel iGPUs) or **Video Acceleration
   API (VAAPI)** (more compatible, slightly less efficient).
3. Set **QSV Device** / **VA-API Device** to `/dev/dri/renderD128`.
4. Enable the codecs your iGPU supports for hardware decoding (H264, HEVC; AV1 on Arc / Gen 12+).
5. Tick **Enable hardware encoding**, **Enable tone mapping**, and **Enable VPP tone mapping** for the best 4K HDR
   experience.
6. Click **Save** at the bottom.

### Verify it's working

While a client is transcoding a video, run on the host:

```shell
intel_gpu_top
```

You should see activity on the Video / VideoEnhance engines. Alternatively, inside the container:

```shell
docker exec -it jellyfin vainfo
```

You should see a list of supported profiles ending in entries like `VAProfileH264High : VAEntrypointEncSlice`. No
profiles or "failed to initialize" means the device passthrough or group membership is wrong.

## Adding more media libraries

The compose file mounts one `MEDIA_LOCATION` at `/media`. To split movies/tv/music across different host paths, edit
`docker-compose.yml` and add more volume lines:

```yaml
volumes:
  - ${CONFIG_LOCATION}:/config
  - ${CACHE_LOCATION}:/cache
  - /mnt/movies:/media/movies
  - /mnt/tv:/media/tv
  - /mnt/music:/media/music
```

Then in Jellyfin's library setup, point each library at the corresponding `/media/...` path inside the container.

## Backups

The `jellyfin_config_backup` sidecar runs nightly at 03:00 and writes a rotated tarball of `${CONFIG_LOCATION}` to
`${BACKUP_LOCATION}`. It briefly stops the Jellyfin container during the dump (a few seconds) so the SQLite databases
are quiesced and the tarball is internally consistent — without this, you can end up with a corrupt `library.db` on
restore.

### What gets backed up

| Service                  | Source               | Destination          | Schedule       | Retention |
| ------------------------ | -------------------- | -------------------- | -------------- | --------- |
| `jellyfin_config_backup` | `${CONFIG_LOCATION}` | `${BACKUP_LOCATION}` | Daily at 03:00 | 30 days   |

The `cache/` directory is excluded — Jellyfin regenerates it on demand. Media files themselves are **not** backed up
here; the assumption is that they are originals you back up separately (or that you can re-rip from physical media).

### Verify backups are running

```shell
ls -lh /mnt/backups/jellyfin/
docker logs jellyfin_config_backup
```

You should see a fresh `jellyfin-config-*.tar.gz` after the first scheduled run.

### Trigger a backup on demand

```shell
docker exec jellyfin_config_backup backup
```

### Off-site copies (recommended)

```shell
rsync -a --delete /mnt/backups/jellyfin/ user@offsite:/backups/jellyfin/
# or
rclone sync /mnt/backups/jellyfin/ remote:jellyfin-backups/
```

The [Borg](../../Backup/borg.md) instructions in this repo also work well for deduplicated off-site backups.

## Restore

The restore process is the same whether you're recovering from data loss or migrating to a new host.

### 1. Stop the stack

```shell
docker compose down
```

### 2. Wipe and re-extract the config directory

```shell
rm -rf /home/joseph/jellyfin/config/*
tar -xzf /mnt/backups/jellyfin/jellyfin-config-2026-05-24T03-00-00.tar.gz \
  -C /home/joseph/jellyfin/config --strip-components=1
```

The tarball stores files under a top-level `config/` directory; `--strip-components=1` drops that prefix so the layout
matches what Jellyfin expects.

### 3. Bring the stack back up

```shell
docker compose up -d
```

Log into the web UI and confirm your users, libraries, watch history, and plugins are intact. The cache will rebuild
itself as clients request media.

### Migrating to a new host

Same procedure, but on the new host: copy `docker-compose.yml`, `.env`, and the backup tarball over, create the host
directories, run the restore, then point the media paths in `.env` at wherever the media now lives. If the in-container
paths (`/media`, `/config`) stay the same, Jellyfin won't notice the move.

## Updating

```shell
docker compose pull
docker compose up -d
```

The `linuxserver/jellyfin:latest` tag rolls forward. If you want to pin to a known-good version (e.g. after a bad
release), change `:latest` in `docker-compose.yml` to a specific tag from
[the image tags list](https://github.com/linuxserver/docker-jellyfin/pkgs/container/jellyfin).

## Troubleshooting

- **Transcodes still show "Software" in the Dashboard**: `RENDER_GID` is wrong, or `/dev/dri` isn't mounted. Check
  `docker exec -it jellyfin vainfo` — if it errors with permission denied, the group is wrong.
- **`vainfo` reports `iHD driver not found`**: very rare on the linuxserver image (which ships the Intel driver). On a
  custom image, install `intel-media-va-driver-non-free` (Debian/Ubuntu) inside the container.
- **Backup tarballs are empty / corrupt**: confirm the `docker-volume-backup.stop-during-backup` label is on the
  jellyfin service and that `/var/run/docker.sock` is mounted into the backup sidecar — without socket access it can't
  stop the container and SQLite snapshots may be inconsistent.
- **Backups balloon in size**: someone enabled subtitle extraction or trickplay images, which Jellyfin stores under
  `/config/data`. That's expected — those files take time to regenerate and are worth keeping.
- **First start takes forever / no web UI**: check `docker logs jellyfin`. A common cause is `PUID`/`PGID` mismatching
  the file ownership of `CONFIG_LOCATION`; fix with `chown -R $PUID:$PGID /home/joseph/jellyfin`.

## References

- Jellyfin Docker docs: <https://jellyfin.org/docs/general/installation/container/>
- Jellyfin hardware acceleration docs: <https://jellyfin.org/docs/general/administration/hardware-acceleration/intel/>
- Linuxserver image: <https://docs.linuxserver.io/images/docker-jellyfin/>
- Volume backup image: <https://github.com/offen/docker-volume-backup>
