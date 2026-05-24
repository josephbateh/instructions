# Immich Docker Setup

[Immich](https://immich.app/) is a self-hosted photo and video management solution — a Google Photos replacement with
mobile apps, machine-learning powered search, face recognition, and albums.

This stack runs Immich plus two backup sidecars so that **automated daily backups of both the database and the upload
library** happen with no further setup. Restoring is a documented, repeatable process.

## What's in the stack

| Container                 | Purpose                                                          |
| ------------------------- | ---------------------------------------------------------------- |
| `immich_server`           | Web UI, API, and background workers. Exposes port 2283.          |
| `immich_machine_learning` | CLIP / face-recognition models. Internal only.                   |
| `immich_redis`            | Job queue. Internal only.                                        |
| `immich_postgres`         | Metadata, albums, faces, users. Uses vectorchord for embeddings. |
| `immich_db_backup`        | Rotated daily `pg_dump` of the Immich database.                  |
| `immich_uploads_backup`   | Rotated daily tarball of the upload library.                     |

## Setup

### 1. Copy the env file and edit it

```shell
cp .env.example .env
$EDITOR .env
```

At minimum set:

- `UPLOAD_LOCATION` — where photos/videos are stored on the host.
- `DB_DATA_LOCATION` — where the Postgres data directory lives.
- `BACKUP_LOCATION` — where automated backups are written. **Point this at a different disk or mount than
  `UPLOAD_LOCATION`** so a single disk failure cannot destroy both at once.
- `DB_PASSWORD` — change from the default.

### 2. Create the host directories

```shell
mkdir -p /home/joseph/immich/library /home/joseph/immich/postgres
mkdir -p /mnt/backups/immich/db /mnt/backups/immich/uploads
```

Adjust the paths to match what you set in `.env`.

### 3. Start the stack

```shell
docker compose up -d
```

The first start pulls the images and initializes the database. Wait ~30 seconds, then open
[http://localhost:2283](http://localhost:2283) and create the admin account.

## Uploading photos

- **Web UI**: drag and drop into the browser at port 2283.
- **Mobile**: install the Immich app (iOS / Android), point it at `http://<your-host>:2283`, sign in, and enable
  background backup of your camera roll.
- **CLI** (bulk import of an existing library):

  ```shell
  npm install -g @immich/cli
  immich login http://<your-host>:2283 <api-key-from-account-settings>
  immich upload --recursive /path/to/photos
  ```

## Backups

Backups run automatically once the stack is up. No cron jobs to install on the host.

### What gets backed up

| Service                 | Source                                      | Destination                   | Schedule       | Retention                |
| ----------------------- | ------------------------------------------- | ----------------------------- | -------------- | ------------------------ |
| `immich_db_backup`      | Postgres (`pg_dumpall`, gzipped)            | `${BACKUP_LOCATION}/db/`      | Daily          | 7 daily, 4 weekly, 6 mo. |
| `immich_uploads_backup` | `${UPLOAD_LOCATION}` (read-only bind mount) | `${BACKUP_LOCATION}/uploads/` | Daily at 03:00 | 30 days of tarballs      |

Both sidecars rotate old backups automatically.

### Verify backups are running

```shell
ls -lh /mnt/backups/immich/db/daily/
ls -lh /mnt/backups/immich/uploads/
docker logs immich_db_backup
docker logs immich_uploads_backup
```

You should see a fresh `.sql.gz` dump and a fresh `immich-uploads-*.tar.gz` after the first scheduled run (or run them
on demand, see below).

### Trigger a backup on demand

Database:

```shell
docker exec immich_db_backup /backup.sh
```

Uploads:

```shell
docker exec immich_uploads_backup backup
```

### Off-site copies (recommended)

A backup on the same machine protects against accidents but not theft, fire, or ransomware. Periodically sync
`${BACKUP_LOCATION}` to off-site storage. Examples:

```shell
# To another machine over SSH
rsync -a --delete /mnt/backups/immich/ user@offsite:/backups/immich/

# To S3-compatible storage via rclone
rclone sync /mnt/backups/immich/ remote:immich-backups/
```

The [Borg](../../Backup/borg.md) instructions in this repo are also a good fit for off-site, deduplicated backups of
`${BACKUP_LOCATION}`.

## Restore

The restore process is the same whether you're recovering from data loss or migrating to a new host. **Both the database
dump and the upload tarball from the same day should be used together** — restoring mismatched versions will leave
orphaned files and broken thumbnails.

### 1. Stand up the stack on the target host

Copy `docker-compose.yml` and `.env` to the new host, create the host directories from step 2 of Setup, and start only
the database:

```shell
docker compose up -d database
```

Wait until `docker ps` shows `immich_postgres` as `healthy`.

### 2. Restore the database

Pick the dump you want to restore from `${BACKUP_LOCATION}/db/` (e.g. `daily/immich-YYYY-MM-DD.sql.gz`) and feed it to
`psql` inside the running Postgres container:

```shell
gunzip -c /mnt/backups/immich/db/daily/immich-2026-05-24.sql.gz \
  | docker exec -i immich_postgres psql --username=postgres
```

The dump was created with `--clean --if-exists`, so it drops and recreates the Immich database in place — no need to
wipe `DB_DATA_LOCATION` first.

### 3. Restore the upload library

Stop the stack so nothing writes to the upload directory mid-restore:

```shell
docker compose down
```

Wipe and re-extract the matching tarball:

```shell
rm -rf /home/joseph/immich/library/*
tar -xzf /mnt/backups/immich/uploads/immich-uploads-2026-05-24T03-00-00.tar.gz \
  -C /home/joseph/immich/library --strip-components=1
```

The tarball stores files under a top-level `upload/` directory; `--strip-components=1` drops that prefix so the layout
matches what Immich expects.

### 4. Bring the stack back up

```shell
docker compose up -d
```

Log into the web UI and confirm your library, albums, and users are intact. Face recognition and smart-search embeddings
are stored in the database and will be present immediately — no re-processing required.

## Updating

```shell
docker compose pull
docker compose up -d
```

If you pinned `IMMICH_VERSION` in `.env`, bump it first. Always
[check the release notes](https://github.com/immich-app/immich/releases) for breaking changes before upgrading.

## Troubleshooting

- **Postgres won't start with a checksum error after a host crash**: the data directory is corrupted. Stop the stack,
  move `DB_DATA_LOCATION` aside, and run the restore procedure against a fresh data directory.
- **`immich_uploads_backup` skips runs**: confirm `BACKUP_LOCATION/uploads` exists on the host and is writable by the
  container's UID.
- **Backups are huge**: the `thumbs/` and `encoded-video/` subdirectories inside `UPLOAD_LOCATION` are regenerated by
  Immich on demand. If you want to exclude them, switch `uploads-backup` to a custom `borgmatic`/`restic` setup with an
  exclude list — the simple tarball sidecar doesn't filter paths.

## References

- Immich docs: <https://immich.app/docs/install/docker-compose>
- DB backup image: <https://github.com/prodrigestivill/docker-postgres-backup-local>
- Volume backup image: <https://github.com/offen/docker-volume-backup>
