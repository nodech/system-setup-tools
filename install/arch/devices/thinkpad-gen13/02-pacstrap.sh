#!/bin/bash

__DIRECTORY=`dirname $0`
source $__DIRECTORY/../../utils/diskType.sh
__DIRECTORY=`dirname $0`
source $__DIRECTORY/../../configs/configs.sh
__DIRECTORY=`dirname $0`

DISK=$CFG_DISK
VOL_GROUP=$CFG_VOL_GROUP

if [[ ! -b $DISK ]]; then
  echo "$DISK is not a disk, aborting..."
  exit 1
fi

# Configure kernel modules and initramfs
echo " --- Configuring kernel modules and crypttab for GRUB..."

# Edit /etc/mkinitcpio.conf
echo " --- Configuring mkinitcpio.conf..."
INIT_HOOKS="HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 resume filesystems fsck)"
INIT_FILE="FILES=(/crypto_keyfile.bin)"
sed -i "s|^HOOKS=.*|$INIT_HOOKS|" /mnt/etc/mkinitcpio.conf
sed -i "s|^FILES=.*|$INIT_FILE|" /mnt/etc/mkinitcpio.conf

echo " --- Configuring GRUB + crypttab..."
LVM_PART=`diskPart ${DISK} 3`
LVM_BLKID=`blkid $LVM_PART | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p'`
GRUB_CMD="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$LVM_BLKID:$CFG_MAPPED_ROOT resume=/dev/$VOL_GROUP/swap\""
GRUB_CRYPTO="GRUB_ENABLE_CRYPTODISK=y"
sed -i "s|^GRUB_TIMEOUT=.*|GRUB_TIMEOUT=5|" /mnt/etc/default/grub
sed -i "s|^GRUB_CMDLINE_LINUX=.*|$GRUB_CMD|" /mnt/etc/default/grub
sed -i "s|^#GRUB_ENABLE_CRYPTODISK=.*|$GRUB_CRYPTO|" /mnt/etc/default/grub

BOOT_PART=`diskPart ${DISK} 2`
echo "cryptboot $BOOT_PART /crypto_keyfile.bin luks" >> /mnt/etc/crypttab

# Hack to make LVM available in chroot
mkdir /mnt/hostlvm
mount --bind /run/lvm /mnt/hostlvm
