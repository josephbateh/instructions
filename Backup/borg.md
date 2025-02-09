# Borg Backup

Documentation: [link](https://borgbackup.readthedocs.io/en/stable/).

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

