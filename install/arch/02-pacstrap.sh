#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- SYSTEM PREPARE ---"

echo "--- Install essential packages..."
pacstrap /mnt \
  base \
  linux \
  linux-firmware \
  intel-ucode \
  base-devel \
  lvm2 \
  grub \
  cmake \
  efibootmgr \
  networkmanager \
  wpa_supplicant \
  sudo \
  man-db \
  man-pages \
  git \
  neovim \
  zsh \
  zsh-syntax-highlighting \
  tmux \
  npm \
  python-pip \
  ruby

## Source: https://wiki.archlinux.org/index.php/Fstab
# The fstab(5) file can be used to define how disk partitions, various other
# block devices, or remote filesystems should be mounted into the filesystem. 
echo " --- Generating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab

echo " --- Copy the install repository to /root/system-setup-tools"
cp -r $__DIRECTORY/../../ /mnt/root/system-setup-tools

_CFG_EXEC="$CFG_DEVICE/02-pacstrap.sh"

if [[ -x "$_CFG_EXEC" ]]; then
  echo " --- Running custom scripts for the device..."
  $_CFG_EXEC
fi



echo "!!! PLEASE TYPE ARCH-CHROOT /mnt AND"
echo "!!! REFER TO THE /root/system-setup-tools"
