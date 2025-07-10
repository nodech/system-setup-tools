#!/bin/sh

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- Wayland and stuff ---"

pacman -S sway \
  alsa-utils \
  alacritty \
  rofi \
  dunst \
  firefox \
  ttf-dejavu \
  fzf \
  ripgrep \
  inetutils \
  rustup \
  os-prober \
  inetutils \
  htop \
  nmap \
  openssh \
  rsync \
  ranger \
  feh

# Check the sway utils
# pacman -S waybar \
#   swaybg \
#   swaylock \
#   swayidle \
#   wl-clipboard \
#   wdisplays \
