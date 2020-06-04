#!/bin/bash

source ./configs/no-enc-disk.sh

echo "--- DISK SETUP ---"

_DISK=""
echo -n " -- Choose disk: "
read _DISK

if [[ ! -b $_DISK ]]; then
  echo "Disk '$_DISK' is not available, aborting..."
  exit 1
fi

echo " --- Current disk setup:"
fdisk -l $_DISK

_BACKUP=""
echo -n " -- Do you want to Back UP current partition table? y/n:"
read _BACKUP

if [[ "$_BACKUP" == "Y" ]]; then
  echo "Backing up partition table to $CFG_BACKUP..."
  sfdisk -d $_DISK > $CFG_BACKUP
fi

_FORMAT_
