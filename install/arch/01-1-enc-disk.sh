#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

_CFG_EXEC="$CFG_DEVICE/01-1-enc-disk.sh"

if [[ ! -x "$_CFG_EXEC" ]]; then
  echo "Could not find $_EXECUTE"
  echo "or it is not executable."
  exit 1
fi

echo "--- ENCRYPTED DISK SETUP ---"

_DISK=$CFG_DISK

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
echo "Executing configuration file $_CFG_EXEC..."
echo "NOTE disk may be wiped depending on configuration."
echo -n "please confirm (Y):"
read _EXECUTE

if [[ "$_EXECUTE" != "Y" ]]; then
  echo "Aborting..."
  exit 2
fi

echo "Running configuration $_CFG_EXEC"
$_CFG_EXEC $_DISK
