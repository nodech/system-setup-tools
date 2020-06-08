#!/bin/bash

## Step - 1 - Initial setup
CFG_KBD="us"
CFG_4KFONT="latarcyrheb-sun32"
## Step - 1 and 3.
CFG_TIMEZONE="Asia/Tbilisi"

## Step - 2 - Partitioning
CFG_BACKUP="$HOME/partition-table.dump"

## Step - 3 Arch-chroot
CFG_LOCALEGEN="en_US.UTF-8 UTF-8
ka_GE.UTF-8 UTF-8"
CFG_LANG="en_US.UTF-8"

CFG_HOSTNAME="lnd"
