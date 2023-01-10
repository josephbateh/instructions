# Ubuntu DNS Fix

## Intent

Allow an install of Ubuntu to run DNS related servers like PiHole. By default, Ubuntu has its own local DNS server listening on port 53. This disables that so other DNS servers can run on Ubuntu.

## Steps

First, execute the command:

```bash
sudo nano /etc/systemd/resolved.conf
```

This will open up a configuration file that looks something like this:

```
[Resolve]
#DNS=
#FallbackDNS=
...
```

There should be no uncommented values (as of writing on 2022-12-17). To force Ubuntu to stop using its local DNS, add this line:

```
[Resolve]
...
DNSStubListener=no
...
```

Once completed, the `resolved` service will need to be stopped and disabled:

```bash
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
```

Next, restart the machine. Afterward, it should be possible to host DNS servers like PiHole on port 53.