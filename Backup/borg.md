# Borg Backup

[Borg](https://borgbackup.readthedocs.io/en/stable/) is a deduplicating backup program that supports compression and
encryption. It's designed to be efficient and secure, saving space by only storing unique data chunks once. Borg
features include fast incremental backups, client-side encryption, data verification, and the ability to mount backups
as a filesystem. It's particularly useful for off-site backups and works well on low-bandwidth connections.

## Create Repository

### With Encryption

```shell
borg init --encryption keyfile /path/to/store/backups
```

### Without Encryption

```shell
borg init --encryption none /path/to/store/backups
```

## Create Backup

### Plain Command

```shell
borg create "/path/to/store/backups::backup-name" /path/to/backup
```

### Command With Dates

```shell
borg create "/Volumes/SN550/Borg::$(date +%Y-%m-%d)" /Volumes/home
```

### Command With Progress & Compression

```shell
borg create --progress --stats --compression lz4 "/Volumes/SN550/Borg::$(date +%Y-%m-%d)" /Volumes/home
```
