#!/bin/bash

__DIRECTORY=`dirname $0`

echo "--- Thinkpad (13 gen) system setup ---"

echo " --- Install firmware updates ---"
# echo " --- Refreshing devices..."
# fwupdmgr refresh

# echo " --- Update firmware (Interactive)..."
# fwupdmgr update

echo " --- Check if S3 is enabled..."
dmesg | grep -i "acpi: (support"

# echo " --- Fixing Throttling issue "
# systemctl enable --now lenovo_fix.service

echo " --- Copying udev rules... "
cp -v $__DIRECTORY/etc/udev/rules.d/* /etc/udev/rules.d/

echo " --- TODO: Set up secure boot here..."
