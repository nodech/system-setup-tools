#!/bin/bash

__DIRECTORY=`dirname $0`

## Setup GRUB.
echo "--- PC-1 system setup ---"

echo " --- Install firmware updates ---"
echo " --- Refreshing devices..."
fwupdmgr refresh

echo " --- Update firmware (Interactive)..."
fwupdmgr update

echo " --- TODO: Set up secure boot here..."
