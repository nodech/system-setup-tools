#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`

source $__DIRECTORY/configs/no-enc-disk.sh

if [[ "$1" == "" || "$2" == "" ]]; then
  echo "Usage: ./01-0-noenc-disk.sh HARDWARE_DEVICE CONFIGURATION_FILE"
  echo "Usage example: ./01-0-noenc-disk.sh /dev/nvme0n1 thinkpad-tb"
  echo "list of available configurations:"
  find $__DIRECTORY/configs/devices/*.sh
  exit 1
fi

echo "--- DISK SETUP ---"

_DISK=$1
_CONFIG=$2

if [[ ! -x "$_CONFIG" ]]; then
  echo "Could not find configuration executable $_CONFIG"
  echo "list of available configurations:"
  find $__DIRECTORY/configs/devices/*.sh
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

_EXECUTE=""
echo "Executing configuration file $_CONFIG..."
echo "NOTE disk may be wiped depending on configuration."
echo -n "please confirm (Y):"
read _EXECUTE

if [[ "$_EXECUTE" != "Y" ]]; then
  echo "Aborting..."
  exit 2
fi

echo "Running configuration $_CONFIG"
$_CONFIG $_DISK
