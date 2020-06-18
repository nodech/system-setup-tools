#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/default-configs.sh

echo "--- SYSTEM PREPARE ---"
echo "--- Install essential packages..."
pacstrap /mnt \
  base \
  linux \
  linux-firmware \
  grub \
  efibootmgr \
  neovim \
  man-db \
  man-pages \
  networkmanager \
  netctl \
  wpa_supplicant \
  git \
  zsh

## Source: https://wiki.archlinux.org/index.php/Fstab
# The fstab(5) file can be used to define how disk partitions, various other
# block devices, or remote filesystems should be mounted into the filesystem. 
echo " --- Generating fstab file..."
genfstab -L /mnt >> /mnt/etc/fstab

echo " --- Copy the install repository to /mnt/home/$CFG_USERNAME/system-setup-tools"
mkdir /mnt/home/$CFG_USERNAME
cp -r $__DIRECTORY/../../ /mnt/home/$CFG_USERNAME/system-setup-tools

echo "!!! PLEASE TYPE ARCH-CHROOT /mnt AND"
echo "!!! REFER TO THE /home/$CFG_USERNAME/system-setup-tools"
