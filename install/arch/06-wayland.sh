#!/bin/sh

__DIRECTORY=`dirname ${BASH_SOURCE[0]}`
source $__DIRECTORY/configs/configs.sh

echo "--- Wayland and stuff ---"

pacman -S alacritty \
  bat \
  ccache \
  dunst \
  feh \
  firefox \
  fprintd \
  fzf \
  grim \
  htop \
  inetutils \
  inetutils \
  lsd \
  nmap \
  openssh \
  os-prober \
  otf-font-awesome \
  pavucontrol \
  pipewire \
  pipewire-alsa \
  pipewire-audio \
  pipewire-pulse \
  ranger \
  ripgrep \
  rofi \
  rsync \
  rustup \
  sccache \
  slurp \
  sway \
  swaybg \
  swayidle \
  swaylock \
  ttf-dejavu \
  udisks2 \
  usbutils \
  vulkan-intel \
  waybar \
  wayland-utils \
  wireplumber \
  wl-clipboard \
  yubikey-personalization-gui \
  zoxide \
