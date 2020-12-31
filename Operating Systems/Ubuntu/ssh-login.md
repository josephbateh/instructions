# SSH Login

Copy SSH public key:

```
ssh-copy-id joseph@hostname
```

Edit SSH config by setting `PasswordAuthentication no`.

```
sudo nano /etc/ssh/sshd_config
sudo service sshd restart
```
