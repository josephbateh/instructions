# Mount Disk

Clean up things

```
sudo fdisk /dev/sda
```

Find disk

```
lsblk
```

```
sudo apt install exfat-fuse exfat-utils
```

Format as ext4

```
sudo mkfs.ext4 -n LABEL /dev/sda1
```

Format as exfat

```
sudo mkfs.exfat -n LABEL /dev/sda1
```

Create mount point and mount

```
sudo mkdir /mnt/storage
sudo mount /dev/sda1 /mnt/storage
```

List disks and get UUID

```
blkid
```

Add UUID to fstab in the format `UUID=be435cb2-25d2-48c2-86a3-5cac73bee36d /mnt/storage ext4 defaults 0 0`.

```
sudo nano /etc/fstab
```

Mount drives

```
sudo mount -a
```

Change ownership

```
sudo chown -R joseph:joseph storage
```

See mounted drives

```
lsblk -f
```