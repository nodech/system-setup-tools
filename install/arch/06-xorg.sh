#!/bin/sh

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- Xorg and stuff ---"

pacman -S xorg-server \
  xf86-video-intel \
  xorg-xinit \
  xss-lock \
  xorg-xrandr \
  xsel \
  alsamixer \
  alacritty \
  rofi \
  dunst \
  firefox \
  xsecurelock \
  i3-wm \
  ttf-dejavu
