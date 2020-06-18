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
There was stupid issue with netctl, it will fail activating the profile
as long as interface is UP.
So, solution is just, to take down interface before using `wifi-menu`:
 - `ip link set dev wlan0 down`
 - `wifi-menu` - which in turn create profile for the network in the `/etc/netctl/`
But it failed to start because `wlan0` interface was already `up`. Solution was
simple though (even though counter-intuitive for me), to disable `wlan0` interface.

Strange, but whatever..

### GIT
 - `pacman -Sy` - update db..
 - `pacman -S git` - Install git.
 - `git clone https://github.com/nodar-chkuaselidze/system-setup-tools.git` (in the HOME folder)
 - `cd system-setup-tools`
 - `git config pull.ff only` - Make sure we only fast forward on cloned repo.

### Installation Process
 Now we can run scripts from 00-...
  - `00-init` - Setup console font, keymap and timezone.
  - `01-0-noenc-disk` - Not encrypted disk formatting.
  - `01-1-enc-disk` - TODO:
    - https://github.com/Thann/arcrypt/blob/master/arcrypt.sh
    - https://wiki.archlinux.org/index.php/LVM
  - `01-...` Should we use LVM? TODO:
    - https://wiki.archlinux.org/index.php/Dm-crypt

### Device specific notes
#### Thinkpad
 You can check full details at https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)

 - Setup Secure Boot (TODO).
 - 
