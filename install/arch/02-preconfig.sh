#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`

echo "--- SYSTEM PREPARE ---"
echo "--- Install essential packages..."
pacstrap /mnt \
  base \
  linux \
  linux-firmware \
  neovim \
  man-db \
  man-pages \
  networkmanager \
  netctl \
  wpa_supplicant \
  git

## Source: https://wiki.archlinux.org/index.php/Fstab
# The fstab(5) file can be used to define how disk partitions, various other
# block devices, or remote filesystems should be mounted into the filesystem. 
echo " --- Generating fstab file..."
genfstab -L /mnt >> /mnt/etc/fstab

echo " --- Copy the install repository to /mnt/tmp"
cp -r $__DIRECTORY/../../ /mnt/tmp/system-setup-tools

echo "!!! NOW REFER TO THE /tmp/system-setup-tools"
echo "Please type arch-chroot /mnt"
