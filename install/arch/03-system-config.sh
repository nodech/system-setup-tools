#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh
#__DIRECTORY=`dirname ${BASH_SOURCE[0]}`

echo "--- SYSTEM SETUP ---"
echo "--- Arch-root step.. ---"

echo " --- Setting up timezone..."
ln -sf /usr/share/zoneinfo/$CFG_TIMEZONE /etc/localtime

echo " --- Generating adjtime..."
hwclock --systohc

echo " --- Setting up localization..."
echo $CFG_LOCALEGEN >> /etc/locale.gen
locale-gen

echo $CFG_LANG > /etc/locale.conf
echo $CFG_HOSTNAME > /etc/hostname
echo "127.0.1.1 $CFG_HOSTNAME.localdomain $CFG_HOSTNAME" >> /etc/hosts

echo "!!! PLEASE PROVIDE PASSWORD FOR ROOT !!!!"
passwd
