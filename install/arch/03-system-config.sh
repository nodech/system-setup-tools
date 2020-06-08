#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/init.sh
__DIRECTORY=`dirname ${BASH_SOURCE[0]}`

echo "--- SYSTEM SETUP ---"
echo "--- Arch-root step.. ---"

## Source: https://wiki.archlinux.org/index.php/Fstab
# The fstab(5) file can be used to define how disk partitions, various other
# block devices, or remote filesystems should be mounted into the filesystem. 
echo " --- Generating fstab file..."
genfstab -L /mnt >> /mnt/etc/fstab

echo " --- Copy the install repository to /mnt/tmp"
cp -r $__DIRECTORY/../../ /mnt/tmp/system-setup-tools


echo " --- Changing root to the /mnt..."
arch-root /mnt
