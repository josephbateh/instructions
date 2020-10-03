#!/bin/bash

# Update
sudo apt -y update
sudo apt -y upgrade

# Install Unattended Upgrades
sudo apt install -y unattended-upgrades

# Turn Off Root Login
sudo usermod -p '!' root

# Only listen on IPV4
echo 'AddressFamily inet' | sudo tee -a /etc/ssh/sshd_config

# Disable SSH password authentication
echo 'PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config

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

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm i v12

# Install Mono
sudo apt install -y mono-complete

sudo reboot

# SSH Key Setup
# https://www.linode.com/docs/security/securing-your-server/
# https://www.linode.com/docs/security/authentication/use-public-key-authentication-with-ssh/