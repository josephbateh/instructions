#!/bin/bash -ex
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
sudo nano /etc/resolv.conf
docker-compose up -d