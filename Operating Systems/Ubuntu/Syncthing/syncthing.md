# Syncthing

## Install

```sh
bash -ex syncthing.sh
```

## Setup


Execute:

```
sudo nano /etc/systemd/system/syncthing.service
```

Paste:

```
[Unit]
Description=Syncthing

[Service]
User=joseph
Group=joseph
Restart=on-failure
RestartSec=20 5
ExecStart=/usr/bin/syncthing -no-browser -gui-address="127.0.0.1:8384" -no-restart -logflags=0

[Install]
WantedBy=multi-user.target
```

Execute:

```
sudo systemctl daemon-reload
sudo systemctl enable syncthing
sudo service syncthing start
```