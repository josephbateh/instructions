#!/bin/bash -ex

# Install TV Tuner Packages
sudo add-apt-repository ppa:b-rad/kernel+mediatree+hauppauge
sudo apt-get update
sudo apt-get install linux-mediatree
sudo apt-get install linux-firmware-hauppauge

# Install Plex
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt update
sudo apt install plexmediaserver
sudo ufw allow 32400
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service