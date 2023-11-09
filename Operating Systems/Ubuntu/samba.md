# Samba Setup

Install Samba

```sh
sudo apt update
sudo apt upgrade -y
sudo apt install samba
```

Create directory

```sh
mkdir samba
```

Create user

```sh
sudo smbpasswd -a joseph
sudo nano /etc/samba/smb.conf
```

Add configuration

```conf
[home]
    comment = homeboi
    path = /home/joseph/samba
    read only = no
    browsable = no
```

Restart Samba service

```sh
sudo service smbd restart
sudo ufw allow samba
```
