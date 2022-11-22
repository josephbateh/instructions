```bash
#!/bin/bash -ex
# sudo systemctl stop systemd-resolved.service
# sudo systemctl disable systemd-resolved.service
# sudo nano /etc/resolv.conf
# docker-compose up -d
```

`nano /etc/systemd/resolved.conf`

```conf
# See resolved.conf(5) for details
[Resolve]
#DNS=
#FallbackDNS=
#Domains=
#LLMNR=no
#MulticastDNS=no
#DNSSEC=no
#Cache=yes
#DNSStubListener=yes
DNSStubListener=no
```
