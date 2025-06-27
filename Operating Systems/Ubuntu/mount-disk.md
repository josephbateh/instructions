# Mount Disk

Clean up things

```bash
sudo fdisk /dev/sda
```

Find disk

```bash
lsblk
```

```bash
sudo apt install exfat-fuse exfat-utils
```

Format as ext4

```bash
sudo mkfs -t ext4 /dev/xvdf
```

Format as exfat

```bash
sudo mkfs -t exfat /dev/xvdf
```

Create mount point and mount

```bash
sudo mkdir /mnt/storage
sudo mount /dev/sda1 /mnt/storage
```

List disks and get UUID

```bash
blkid
sudo lsblk -f
```

Add UUID to fstab in the format `UUID=be435cb2-25d2-48c2-86a3-5cac73bee36d /mnt/storage ext4 defaults 0 0`.

```bash
sudo nano /etc/fstab
```

Mount drives

```bash
sudo mount -a
```

Change ownership

```bash
sudo chown -R joseph:joseph storage
```

See mounted drives

```bash
lsblk -f
```
