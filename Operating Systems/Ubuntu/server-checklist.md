# Ubuntu Server Checklist

## Backing Up

- [ ] Back up Docker services.
- [ ] Nacl up crontab: `sudo ls /var/spool/cron/crontabs`
- [ ] Back up files.
- [ ] Back up Samba config: `sudo cat /etc/samba/smb.conf`
- [ ] Back up SyncThing configuration.
- [ ] Back up `systemd` services: `ls /etc/systemd/system/`

## Setting Up

- [ ] Execute hardening script.
- [ ] Set up SSH keys.
- [ ] Make sure password login is disabled.
- [ ] Make sure disk is encrypted.
- [ ] Set up Docker services.
- [ ] Set up crontab.
- [ ] Set up Samba.
- [ ] Set up SyncThing.
