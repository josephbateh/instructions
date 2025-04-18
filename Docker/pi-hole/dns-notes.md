# Ubuntu DNS Fix

## Intent

Allow an install of Ubuntu to run DNS related servers like PiHole. By default, Ubuntu has its own local DNS server
listening on port 53. This disables that so other DNS servers can run on Ubuntu.

## Steps

First, execute the command:

```bash
sudo nano /etc/systemd/resolved.conf
```

This will open up a configuration file that looks something like this:

```conf
[Resolve]
#DNS=
#FallbackDNS=
...
```

There should be no uncommented values (as of writing on 2022-12-17). To force Ubuntu to stop using its local DNS, add
this line:

```conf
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

## Update PiHole Settings

Go to `Settings -> DNS -> Interface settings` and set it to `Respond only on interface eth0` instead of
`Allow only local requests`. This is an issue because if responding only to local requests, the container deems the host
"the Ubuntu machine" as the only local request (one hop away).

## Update

As of March 16, 2025 this didn't work. The following commands fixed the issue:

```sh
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl restart systemd-resolved
```

This was not fully investigated, it could've been due to a bug in Ubuntu from an operating system update.
