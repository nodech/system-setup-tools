#!/bin/bash

diskType() {
  local disk=$1
  local diskName=`basename $disk`

  if [[ "$diskName" == sd* ]]; then
    echo "SATA"
  elif [[ "$diskName" == nvme* ]]; then
    echo "NVME"
  else
    echo "Could not determine the $disk type."
    exit 1
  fi
}

diskPart() {
  local disk=$1
  local partitionNumber=$2
  local type=`diskType $disk`

  [[ $? -ne 0 ]] && exit 1

  if [[ $type == "SATA" ]]; then
    echo ${disk}$partitionNumber
    exit 0
  fi

  if [[ $type == "NVME" ]]; then
    echo ${disk}p$partitionNumber
    exit 0
  fi
}
