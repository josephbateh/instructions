# MOUNT HARD DRIVE
sudo apt-get install parted
lsblk
sudo parted /dev/sda mklabel gpt
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L data /dev/sda1
sudo e2label /dev/sda1 data
sudo lsblk --fs
sudo mkdir -p /mnt/data
sudo chown joseph:joseph /mnt/data
sudo mount -o defaults /dev/sda1 /mnt/data
sudo nano /etc/fstab
sudo hdparm -S 60 /dev/sda

## Use one of the identifiers you found to reference the correct partition
<!-- /dev/sda1 /mnt/data ext4 defaults 0 2 -->
<!-- UUID=11e1d3c9-f582-5484-b1a7-93de564438a4 /mnt/data ext4 defaults 0 2 -->
LABEL=data /mnt/data ext4 defaults 0 2

sudo mount -a