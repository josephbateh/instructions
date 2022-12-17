# Minecraft

## Initial Setup

Install dependencies

```sh
sudo dpkg --add-architecture i386; sudo apt update; sudo apt install curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 libsdl2-2.0-0:i386 steamcmd
```

Download server file

```
steamcmd +force_install_dir /home/joseph/games/valheim +login anonymous +app_update 896660 validate +quit
```

Edit name/pass

```
nano start_server.sh
```

Start and get status

```
sudo nano /etc/systemd/system/valheim-server.service
sudo systemctl daemon-reload
sudo systemctl enable valheim-server
sudo service valheim-server start
sudo systemctl status valheim-server.service
```