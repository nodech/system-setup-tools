#!/bin/bash

__DIRECTORY=`dirname $0`
source $__DIRECTORY/../../utils/diskType.sh
__DIRECTORY=`dirname $0`

## Special thanks to Than:
# https://github.com/Thann/arcrypt/blob/master/arcrypt.sh

## Thinkpad Gen 13 has 1000 GB SSD.
# nvme0n1p1 - /efi EFI System Partition - 1 GB
# nvme0n1p2 - /boot Boot Partition - 1 GB
#
# LVM on LUKS
# nvme0n1p4 - LVM2 PV - Rest 998 GB?
#  - LVM2 VG - swap - 40 GB
#  - LVM2 VG - / - 150 GB
#  - LVM2 VG - /home/ - REST (808 GB?)

DISK=$CFG_DISK

if [[ ! -b $DISK ]]; then
  echo "$DISK is not a disk, aborting..."
  exit 1
fi

## sgdisk types:
# ef00 - EFI system partition
# 8300 - Linux filesystem LVM
## 8e00 - LVM (Not used here.)

echo " --- Wiping current disk..."
wipefs --force --all $DISK # Wipe disk.

echo " --- Deleting partition information..."
sgdisk -o $DISK # Delete partition information

echo " --- Creating EFI System Partition (1G)"
sgdisk -n 1:0:+1G   -t 1:ef00 -c 1:"EFI System Partition" $DISK
echo " --- Creating Boot Partition (1G)"
sgdisk -n 2:0:+1G   -t 2:8300 -c 2:"Boot Partition" $DISK
echo " --- Creating LVM on LUKS Partition (Rest of the disk, 650G)"
sgdisk -n 3:0:0 -t 3:8e00 -c 3:"LVM on LUKS" $DISK

echo " --- Partition Table is ready. Formatting partitions..."

## Now format.

EFI_PART=`diskPart ${DISK} 1`
BOOT_PART=`diskPart ${DISK} 2`
MAPPED_BOOT=$CFG_MAPPED_BOOT

ROOT_PART=`diskPart ${DISK} 3`
MAPPED_ROOT=$CFG_MAPPED_ROOT

VOL_GROUP=$CFG_VOL_GROUP

echo " --- Formatting EFI System Partition to FAT32..."
mkfs.fat -F32 $EFI_PART

PASSWORD=""
while [ -z "$PASSWORD" ]; do
    echo -n " == Set DISK Password:"
    read -s -r _TEMP_PWORD; echo
    echo -n " == Confirm DISK Password:"
    read -s -r _TEMP_PWORD_2; echo
    if [ "$_TEMP_PWORD" == "$_TEMP_PWORD_2" ]
    then
      PASSWORD="$_TEMP_PWORD";
    else
      echo "Passwords do not match, please try again."
      exit 1
    fi
done

# Generate LUKS keyfile.
echo " --- Generating LUKS keyfile..."
LUKS_KEYFILE="/tmp/luks-keyfile"
dd if=/dev/urandom of=$LUKS_KEYFILE bs=512 count=4

# Prepare main partition
echo " --- Boot LUKS partition..."
cryptsetup luksFormat $ROOT_PART --type luks2 --key-file $LUKS_KEYFILE -q
echo " --- Adding key to LUKS partition..."
cryptsetup luksAddKey $ROOT_PART --key-file $LUKS_KEYFILE -q <<< "$PASSWORD"
echo " --- Opening LUKS partition..."
cryptsetup open $ROOT_PART $MAPPED_ROOT --key-file $LUKS_KEYFILE
# Prepare LVM on LUKS
echo " --- Creating LVM on LUKS..."
pvcreate /dev/mapper/$MAPPED_ROOT
echo " --- Creating Volume Group..."
vgcreate $VOL_GROUP /dev/mapper/$MAPPED_ROOT
# Create logical volumes.
echo " --- Creating Logical Volumes..."
lvcreate -L 40G -n swap $VOL_GROUP
lvcreate -L 150G -n root $VOL_GROUP
lvcreate -l 100%FREE -n home $VOL_GROUP

# Format the logical volumes.
echo " --- Formatting LVM Logical Volumes..."
mkfs.ext4 /dev/$VOL_GROUP/root
mkswap /dev/$VOL_GROUP/swap
mkfs.ext4 /dev/$VOL_GROUP/home

# Prepare boot partition.
echo " --- Boot LUKS partition..."
# We use luks1 for GRUB.
cryptsetup luksFormat $BOOT_PART --type luks1 --key-file $LUKS_KEYFILE -q
cryptsetup luksAddKey $BOOT_PART --key-file $LUKS_KEYFILE -q <<< "$PASSWORD"
cryptsetup open $BOOT_PART $MAPPED_BOOT --key-file $LUKS_KEYFILE
echo " --- Formatting boot partition..."
mkfs.ext4 /dev/mapper/cryptboot

echo ""
echo " --- Mounting partitions in /mnt..."

echo " --- Mounting /"
mount /dev/$VOL_GROUP/root /mnt
mkdir /mnt/{efi,boot,home}

echo " --- Mounting /efi"
mount `diskPart ${DISK} 1` /mnt/efi
echo "Swap partition"
swapon /dev/$VOL_GROUP/swap
echo " --- Mounting /home"
mount /dev/$VOL_GROUP/home /mnt/home
echo " --- Mounting /boot"
mount /dev/mapper/$MAPPED_BOOT /mnt/boot

mv $LUKS_KEYFILE /mnt/crypto_keyfile.bin
chmod 000 /mnt/crypto_keyfile.bin
