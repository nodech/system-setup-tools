#!/bin/bash

__DIRECTORY=`dirname $0`

echo "--- OS Prober ---"
pacman -S os-prober

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
