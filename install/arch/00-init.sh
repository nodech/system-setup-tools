#!/bin/sh

echo "--- Initial setup ---"

# Do we use 4k or something. (make font bigger)
_SETFONT=""

echo -n " --- Do you want to enable font: latarcyrheb-sun32, type Y: "
read  _SETFONT

if ["$_CONFIRM" != "Y"]; then
  setfont latarcyrheb-sun32;
  cp ./etc/vconsole.conf /etc/
fi
