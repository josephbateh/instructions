# Samba Setup

Install Samba

```
sudo apt update
sudo apt upgrade -y
sudo apt install samba
```

Create directory

```
mkdir samba
```

Create user

```
sudo smbpasswd -a joseph
sudo nano /etc/samba/smb.conf
```

Add configuration

```
[home]
    comment = homeboi
    path = /home/joseph/samba
    read only = no
    browsable = no
```

Restart Samba service

```
sudo service smbd restart
sudo ufw allow samba
```