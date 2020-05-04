#! /bin/bash

#programs
pacman -S --noconfirm grub os-prober mtools dhcpcd vim git make wget xorg-server xorg-xinit curl

# Set date time
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
echo "en_US.UTF-8 UTF-8
pl_PL.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen

# Set hostname
echo "ARCH" >> /etc/hostname
echo "
127.0.0.1	localhost
::1		localhost
127.0.1.1	ARCH" >> /etc/hosts

# Set root password
echo "root pasword"
echo -en "1\n1" | passwd

# Useradd,internet and sudo 
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers
systemctl enable dhcpcd
useradd -m tajo48
echo "user pasword"
echo -en "1\n1" | passwd tajo48
usermod -aG wheel,audio,video,optical,storage,users tajo48

# Install bootloader
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

#i3 wm
pacman -S --noconfirm i3 feh firefox rxvt-unicode rofi
echo "exec i3" >> ~/.xinitrc
curl https://raw.githubusercontent.com/tajo48/2/master/wallpaper.jpg -O a.jpg
startx
init 3
sed '4 i TEST123TEST123' .config/i3/config
vim .config/i3/config
