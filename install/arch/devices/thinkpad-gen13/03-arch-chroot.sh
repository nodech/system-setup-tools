#!/bin/bash

__DIRECTORY=`dirname $0`

# Make LVM Available
ln -s /hostlvm /run/lvm

## Setup GRUB.
echo "--- GRUB Setup ---"

pushd /
echo " --- Install GRUB at /efi..."
grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=GRUB

echo " --- Create custom entries in /etc/grub.d/40_custom..."
echo "
menuentry \"System shutdown\" {
  echo \"System shutting down...\"
  halt
}

menuentry \"System restart\" {
  echo \"System rebooting...\"
  reboot
}
" >> /etc/grub.d/40_custom

echo " --- Create grub configuration file..."
grub-mkconfig -o /boot/grub/grub.cfg

popd

echo " --- Install some other packages.."
pacman -S fwupd intel-ucode

echo " --- Regenerate initramfs image... (This may take a while)"
mkinitcpio -p linux

chmod 600 /boot/initramfs-linux*
