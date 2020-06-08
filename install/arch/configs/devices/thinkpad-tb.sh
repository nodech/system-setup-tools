#!/bin/bash

__DIRECTORY=`dirname $0`
source $__DIRECTORY/../../utils/diskType.sh
__DIRECTORY=`dirname $0`

## Thinkpad has 1TB SSD.
# NOTE: Currently this script is NVME only.
# nvme0n1p1 - EFI. - 2GB
# nvme0n1p2 - /boot - 1GB
# nvme0n1p3 - SWAP - 20GB
# nvme0n1p4 - / - 100GB
# nvme0n1p5 - /home - 150 GB
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
echo " --- Creating Swap Partition (20G)"
sgdisk -n 3:0:+20G  -t 3:8200 -c 3:"Swap Partition" $DISK
echo " --- Creating Root Partition (100G)"
sgdisk -n 4:0:+100G -t 4:8304 -c 4:"Root Partition" $DISK
echo " --- Creating Home Partition (150G)"
sgdisk -n 5:0:+150G -t 5:8302 -c 5:"Home Partition" $DISK

echo " --- Partition Table is ready. Formatting partitions..."

# NOTE: NVM Express partition names go like:
# nvme0n1
# | - nvme0n1p1
# | - nvme0n1p2
# ...

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

# Now we can mount the file system.
# We first need mount `root (/)`
mount `diskPart ${DISK} 4` /mnt

mkdir /mnt/{efi,boot,home}
mount `diskPart ${DISK} 1` /mnt/efi
mount `diskPart ${DISK} 2` /mnt/boot
mount `diskPart ${DISK} 5` /mnt/home
