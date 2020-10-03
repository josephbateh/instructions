#!/bin/bash

# Update
sudo apt -y update
sudo apt -y upgrade

# Install Docker
sudo apt install -y unattended-upgrades

# Turn Off Root Login
sudo usermod -p '!' root

# Only listen on IPV4
echo 'AddressFamily inet' | sudo tee -a /etc/ssh/sshd_config

# Restart SSH
sudo systemctl restart sshd

# Install fail2ban
sudo apt install -y fail2ban

# Enable firewall
sudo ufw allow ssh
yes | sudo ufw enable

# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker joseph
sudo apt install -y docker-compose
sudo dockerd