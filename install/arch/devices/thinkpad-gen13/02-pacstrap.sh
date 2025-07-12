#!/bin/bash

__DIRECTORY=`dirname $0`

# Configure kernel modules and initramfs
echo " --- Configuring kernel modules and initramfs..."

# Edit /etc/mkinitcpio.conf
INIT_HOOKS="HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 resume filesystems fsck)"
INIT_FILE="FILES=(/crypto_keyfile.bin)"
sed -i "s|^HOOKS=.*|$INIT_HOOKS|" /mnt/etc/mkinitcpio.conf
sed -i "s|^FILES=.*|$INIT_FILE|" /mnt/etc/mkinitcpio.conf

