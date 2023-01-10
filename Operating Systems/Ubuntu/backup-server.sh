#!/bin/bash -ex

# Get sudo access
sudo -v

# Variables
INFLUX_VOLUME=influx_influxdb-storage
GRAFANA_VOLUME=grafana_grafana-storage
BACKUP_DIRECTORY="${HOME}/fullbackup"
CRONTAB_DIRECTORY="${BACKUP_DIRECTORY}/crontabs"
SYSTEMD_DIRECTORY="${BACKUP_DIRECTORY}/systemd"
DOCKERVOLUME_DIRECTORY="${BACKUP_DIRECTORY}/dockervolume"

# Make directory
sudo rm -rf "${BACKUP_DIRECTORY:?}"
mkdir -p "${BACKUP_DIRECTORY}"

# Copy crontab files
mkdir -p "${CRONTAB_DIRECTORY}"
sudo cp -r /var/spool/cron/crontabs "${CRONTAB_DIRECTORY}"

# Copy systemd services
mkdir -p "${SYSTEMD_DIRECTORY}"
sudo cp -r /lib/systemd/systemd "${CRONTAB_DIRECTORY}"

# Copy docker volumes
mkdir -p "${DOCKERVOLUME_DIRECTORY}"
docker run --rm -v "${INFLUX_VOLUME}:/data" -v "${DOCKERVOLUME_DIRECTORY}:/backup" busybox tar cvzf /backup/influx.tgz /data
docker run --rm -v "${GRAFANA_VOLUME}:/data" -v "${DOCKERVOLUME_DIRECTORY}}:/backup" busybox tar cvzf /backup/grafana.tgz /data

# Tar the directory
date=$(date +%Y-%m-%d)
tar -cvzf "backup-${date}.tgz" "${BACKUP_DIRECTORY}"
