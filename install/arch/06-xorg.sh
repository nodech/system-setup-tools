#!/bin/sh

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- Xorg and stuff ---"

pacman -S xorg-server \
  xf86-video-intel \
  xorg-xinit \
  xorg-xrandr \
  xsel \
  alsa-utils \
  alacritty \
  rofi \
  dunst \
  firefox \
  xss-lock \
  xsecurelock \
  i3-wm \
  ttf-dejavu \
  fzf \
  the_silver_searcher \
  inetutils \
  rustup \
  os-prober \
  inetutils \
  htop \
  nmap \
  openssh \
  rsync \
  ranger \
  picom \
  feh
