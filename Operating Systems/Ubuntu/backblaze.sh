#!/bin/bash -ex

### Install B2 CLI ###

sudo wget https://github.com/Backblaze/B2_Command_Line_Tool/releases/latest/download/b2-linux -O /usr/local/bin/b2 -q
sudo chmod +x /usr/local/bin/b2
b2 account authorize
