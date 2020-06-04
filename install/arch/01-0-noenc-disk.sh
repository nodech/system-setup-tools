#!/bin/bash

source ./configs/no-enc-disk.sh

echo "--- DISK SETUP ---"

_DISK=$1

if [[ ! -b "$_DISK" ]]; then
  echo -n " -- Choose disk: "
  read _DISK
fi

if [[ ! -b $_DISK ]]; then
  echo "Disk '$_DISK' is not available, aborting..."
  exit 1
fi

echo " --- Current disk setup:"
fdisk -l $_DISK

_BACKUP=""
echo -n " -- Do you want to Back UP current partition table? Y/N:"
read _BACKUP

if [[ "$_BACKUP" == "Y" ]]; then
  echo "Backing up partition table to $CFG_BACKUP..."
  sfdisk -d $_DISK > $CFG_BACKUP
fi

_DELETE=""
echo -n "Deleteing partition table, confirm to continue(Y):"
read _DELETE

if [[ "$_DELETE" != "Y" ]]; then
  echo "Deleteing partition table..."
  sfdisk --delete $_DISK
  exit 2
fi
