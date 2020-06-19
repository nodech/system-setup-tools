#!/bin/bash

__DIRECTORY=`dirname $0`

## Setup GRUB.
echo "--- Thinkpad (6gen) system setup ---"

echo " --- Install firmware updates ---"
echo " --- Refreshing devices..."
fwupdmgr refresh

echo " --- Update firmware (Interactive)..."
fwupdmgr update

echo " --- Check if S3 is enabled..."
dmesg | grep -i "acpi: (support"

echo " --- Fixing Throttling issue "
system enable --now lenovo_fix.service

echo " --- TODO: Set up secure boot here..."
