#! /bin/bash

# Timectl
timedatectl set-ntp true

# Font
loadkeys pl
setfont Lat2-Terminus16.psfu.gz -m 8859-2

# Setup the disk and partitions
parted /dev/sda --script mklabel msdos
parted /dev/sda --script mkpart primary linux-swap 1MiB 300MiB #boot /dev/sda1
parted /dev/sda --script mkpart primary ext4 300MiB 100% #root /dev/sda2
parted /dev/sda --script set 2 boot on

# Wipefs
wipefs /dev/sda1
wipefs /dev/sda2

# Mkfs
mkfs.ext4 /dev/sda2
mkswap /dev/sda1

# Set up time
timedatectl set-ntp true

# Initate pacman keyring
<<com
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys
com

# Mount the partitions
mount /dev/sda2 /mnt
mkdir /mnt/boot
swapon /dev/sda1

# Install Arch Linux
pacstrap /mnt base linux pacman sudo

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Add sudo to wheel
echo "%wheel ALL=(ALL) ALL 
$(cat /etc/sudoers)" > /etc/sudoers

# Copy post-install system cinfiguration script to new /root
    wget https://raw.githubusercontent.com/tajo48/2/master/after.sh -O /mnt/root/after.sh
    chmod +x /mnt/root/after.sh

# Chroot into new system
arch-chroot /mnt /root/after.sh

