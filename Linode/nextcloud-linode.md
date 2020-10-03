# Install Nextcloud on Ubuntu 16.04 LTS

## Install Nextcloud

```
sudo snap install nextcloud
```

## Lets Encrypt Certificate

```
sudo ufw allow 80,443/tcp
sudo nextcloud.enable-https lets-encrypt
```
