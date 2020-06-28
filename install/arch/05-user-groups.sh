#!/bin/sh

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- User(s) and Group(s) ---"
echo " --- Make sure network is enabled..."
read

useradd -m -s /bin/zsh -G wheel,video,adm,log,sys $CFG_USERNAME

echo "Set password for user:"
passwd $CFG_USERNAME

echo "You need to modify /etc/sudoers file to enable wheel group."
