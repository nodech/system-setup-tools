#!/bin/bash

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- SYSTEM SETUP ---"
echo " --- Make sure network is enabled..."
read

_CFG_EXEC="$CFG_DEVICE/04-system-setup.sh"

if [[ ! -x "$_CFG_EXEC" ]]; then
  echo "Could not find $_CFG_EXEC file to execute.."
  exit 1
fi

$_CFG_EXEC
