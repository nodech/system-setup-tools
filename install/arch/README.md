Installing Archlinux
====================


## Creating USB flash installation media
### MacOS
Source: https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_macOS  
Creating USB Media for installing from MacOS:
 - `diskutil list`
 - `diskutil unmountDisk /dev/diskX`
 - `dd if=/path/to/iso/file of=/dev/diskX bs=1m`

## Archiso steps.

### Network setup
#### Wireless
There was stupid issue with netctl. I created profile using:
 - `wifi-menu` - which in turn create profile for the network in the `/etc/netctl/`
But it failed to start because `wlan0` interface was already `up`. Solution was
simple though (even though counter-intuitive for me), to disable `wlan0` interface.
 - `ip link set dev wlan0 down`

Strange, but whatever..

### GIT
 - `pacman -Sy` - update db..
 - `pacman -S git` - Install git.
 - `git config pull.ff only` - Make sure we only fast forward on cloned repo.
 - `git clone https://github.com/nodar-chkuaselidze/system-setup-tools.git` (in the HOME folder)

### Installation Process
 Now we can run scripts from 00-...
  - `00-init` - Setup console font, keymap and timezone.
