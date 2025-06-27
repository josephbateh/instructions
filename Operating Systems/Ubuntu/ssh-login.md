# SSH Login

Copy SSH public key:

```bash
ssh-copy-id joseph@hostname
```

Edit SSH config by setting `PasswordAuthentication no`.

```bash
sudo nano /etc/ssh/sshd_config
sudo service sshd restart
```
