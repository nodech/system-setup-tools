#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`

source $__DIRECTORY/configs/init.sh

echo "--- Initial setup ---"

# Verify we are in UEFI MODE.
echo " --- Verifying boot mode..."

if [[ -d /sys/firmware/efi/efivars ]]; then
  echo " --- UEFI MODE is 'enabled' !"
else
  echo " --- UEFI MODE is 'DISABLED' ! Aborting..."
  exit 1
fi

echo " --- Setting keyboard layout to $CFG_KBD..."
loadkeys $CFG_KBD

# Do we use 4k or something. (make font bigger)
_SETFONT=""

echo -n " -- Do you want to enable font: $CFG_4KFONT, type Y: "
read  _SETFONT

if [[ "$_CONFIRM" == "Y" ]]; then
  echo " --- Setting font to $CFG_4KFONT..."
  setfont $CFG_4KFONT

  echo " --- Creating vconsole.conf in /etc..."
  echo -e "FONT=$CFG_4KFONT\nKEYMAP=$CFG_KBD\n" > /etc/vconsole.conf
fi

echo " --- Setting up NTP..."
timedatectl set-ntp true
echo " --- Setting timezone to $CFG_TIMEZONE..."
timedatectl set-timezone $CFG_TIMEZONE
timedatectl status

_VIMRC=""
echo -n " --- Do you want to create tmp vimrc file? type (Y): "
read _VIMRC

if [[ "$_VIMRC" == "Y" ]]; then
  echo " --- Creating $HOME/.vimrc file."
  echo "
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set autoindent
" > $HOME/.vimrc
fi
