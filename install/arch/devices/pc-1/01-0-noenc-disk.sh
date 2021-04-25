#!/bin/bash

__DIRECTORY=`dirname $0`
source $__DIRECTORY/../../utils/diskType.sh
__DIRECTORY=`dirname $0`

## PC has 1 TB SSD.
# sda1 - EFI. - 2GB
# sda2 - /boot - 1GB
# sda3 - SWAP - 32GB
# sda4 - / - 150GB
# sda5 - /home - 300 GB
# Rest is unallocated for now.

DISK="$1"

if [[ ! -b $DISK ]]; then
  echo "$DISK is not a disk, aborting..."
  exit 1
fi

## sgdisk types:
# ef00 - EFI system partition
# 8300 - Linux filesystem
# 8200 - Linux swap
# 8304 - Linux x86-64 root (/)
# 8302 - Linux /home
## 8e00 - LVM (Not used here.)

echo " --- Wiping current disk..."
wipefs --force --all $DISK # Wipe disk.

echo " --- Deleting partition information..."
sgdisk -o $DISK # Delete partition information

echo " --- Creating EFI System Partition (1G)"
sgdisk -n 1:0:+1G   -t 1:ef00 -c 1:"EFI System Partition" $DISK
echo " --- Creating Boot Partition (1G)"
sgdisk -n 2:0:+1G   -t 2:8300 -c 2:"Boot Partition" $DISK
echo " --- Creating Swap Partition (32G)"
sgdisk -n 3:0:+32G  -t 3:8200 -c 3:"Swap Partition" $DISK
echo " --- Creating Root Partition (150G)"
sgdisk -n 4:0:+150G -t 4:8304 -c 4:"Root Partition" $DISK
echo " --- Creating Home Partition (300G)"
sgdisk -n 5:0:+300G -t 5:8302 -c 5:"Home Partition" $DISK

echo " --- Partition Table is ready. Formatting partitions..."

# For SATA/PCIe connected devices it goes like:
# sda
# | - sda1
# | - sda2
# ...

echo " --- Formatting EFI System Partition to FAT32..."
mkfs.fat -F32 `diskPart ${DISK} 1`
echo " --- Formatting BOOT Partition to EXT4..."
mkfs.ext4 `diskPart ${DISK} 2`
echo " --- Formatting SWAP Partition..."
mkswap `diskPart ${DISK} 3`
echo " --- Formatting Root Partition..."
mkfs.ext4 `diskPart ${DISK} 4`
echo " --- Formatting Home Partition..."
mkfs.ext4 `diskPart ${DISK} 5`


echo ""
echo " --- Mounting partitions in /mnt..."

echo " --- Mounting /"
# Now we can mount the file system.
# We first need mount `root (/)`
mount `diskPart ${DISK} 4` /mnt

echo " --- Creating /home, /boot, /efi directories"
mkdir /mnt/{efi,boot,home}
echo " --- Mounting /efi"
mount `diskPart ${DISK} 1` /mnt/efi
echo " --- Mounting /boot"
mount `diskPart ${DISK} 2` /mnt/boot
echo " --- Mounting /home"
mount `diskPart ${DISK} 5` /mnt/home
