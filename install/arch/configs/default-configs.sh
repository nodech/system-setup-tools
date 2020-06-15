#!/bin/bash

__CFG_DIR=`dirname ${BASH_SOURCE[0]}`

## CFG_DEVICE env variable is used to
## look up device configuration/scripts.
if [[ ! -d "$CFG_DEVICE" ]]; then
  echo "CFG_DEVICE env variable check failed.."
  echo "Could not find ${CFG_DEVICE} directory."

  echo "Available device configurations:"
  find $__CFG_DIR/../devices/* -type d
  exit 1
fi

if [[ ! -f "$CFG_DEVICE/configs.sh" ]]; then
  echo "Could not find configs.sh file in $CFG_DEVICE/ dirctory."
  exit 2
fi

## Live USB Installer configurations (00-init)
# Keyboard layout.
CFG_KBD="us"
# Sometimes (Happened once?) highres screen
# is not scaled properly and letters are too small.
# This basically fixes that problem.
CFG_4KFONT="latarcyrheb-sun32"

## 00-init (installer) and 02-preconfig (installed system).
# Timezone for the system.
# You can list timezones using `timedatectl list-timezone`
# or in /usr/share/zoneinfo/../..
# Check current status using `timedatectl status`.
CFG_TIMEZONE="Asia/Tbilisi"

## Step - 1 - Partitioning
CFG_BACKUP="$HOME/partition-table.dump"

## 02-preconfig (Get home directory ready) and 04-user-groups
# Username/Group configurations
CFG_USERNAME="nd"

## 03-system-config - Installed system configurations.
CFG_LOCALEGEN="en_US.UTF-8 UTF-8
ka_GE.UTF-8 UTF-8"
CFG_LOCALE="LANG=en_US.UTF-8"

# Network name of the device.
# Most likely rewritten by Device based configs.
CFG_HOSTNAME="nd"

## Rewrite local configs with device specific configurations.
source $CFG_DEVICE/configs.sh
