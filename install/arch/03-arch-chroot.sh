#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- Arch-root step.. ---"

_CFG_EXEC="$CFG_DEVICE/03-arch-chroot.sh"

if [[ -x "$_CFG_EXEC" ]]; then
  echo " --- Running custom scripts for the device..."
  $_CFG_EXEC
fi

echo " --- Setting up timezone..."
ln -sf /usr/share/zoneinfo/$CFG_TIMEZONE /etc/localtime

echo " --- Generating adjtime..."
hwclock --systohc

echo " --- Setting up localization..."
echo -e "$CFG_LOCALEGEN" >> /etc/locale.gen
locale-gen

echo " --- Creating /etc/locale.conf"
echo "$CFG_LOCALE" > /etc/locale.conf
echo " --- Creating /etc/hostname"
echo "$CFG_HOSTNAME" > /etc/hostname
echo " --- Updating /etc/hosts"
echo "127.0.1.1 $CFG_HOSTNAME.localdomain $CFG_HOSTNAME" >> /etc/hosts

echo " --- Enable NetworkManager..."
systemctl enable NetworkManager
systemctl start NetworkManager

echo "--- Installing neovim dependencies ---"
echo " --- Installing neovim for node..."
npm i -g neovim
echo " --- Installing neovim for python3..."
pip install neovim
echo " --- Installing neovim for ruby..."
gem install neovim

echo "!!! PLEASE PROVIDE PASSWORD FOR ROOT !!!!"
passwd

echo "!!! Now you can start using the system and continue running other scripts in the system !!!"
