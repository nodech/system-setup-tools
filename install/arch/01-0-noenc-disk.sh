#!/bin/bash

source ./configs/no-enc-disk.sh

if [[ "$1" == "" || "$2" == "" ]]; then
  echo "Usage: ./01-0-noenc-disk.sh HARDWARE_DEVICE CONFIGURATION_FILE"
  echo "Usage example: ./01-0-noenc-disk.sh /dev/nvme0n1 thinkpad-tb"
  echo "list of available configurations:"
  ls ./configs/devices
  exit 1
fi

echo "--- DISK SETUP ---"

_CONFIG=$2

if [[ ! -f "$_CONFIG" ]]; then
  echo "Could not find configuration file $_CONFIG"
  echo "list of available configurations:"
  ls ./configs/devices
  exit 1
fi

source $_CONFIG
if [[ "$CFG_CREATE_DISK" == "" ]]; then
  echo "CFG_CREATE_DISK variable is not defined in the config file $_CONFIG"
  exit 1
fi

_DISK=$1
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
  echo "Aborting..."
  exit 2
fi

echo "Deleteing partition table..."
sfdisk --delete $_DISK

fdisk --wipe=always $_DISK < $CFG_CREATE_DISK
