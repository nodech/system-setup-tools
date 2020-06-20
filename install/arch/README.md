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
  - `02-pacstrap` - install required packages for the system, generating fstab
  and get ready to use arch-chroot.
  - `03-arch-chroot` - Now we need to get basic system configurations before
  we go into the installed system, this includes:
    - Setting up timezone
    - Localization (locale.gen, locale.conf)
    - hostname and hosts configs
    - NetworkManager daemon (service)
    - Install neovim dependencies
    - Change root password.
    - Device specific configurations include:
      - Install and Configure `grub`. 
      - (optional) install device specific dependencies (e.g. throttled)
  - `04-system-setup` - from this point on, we are logged into the actual system
  Currently, this runs device specific script only:
    - thinkpad: Install firmware updates.
    - thinkpad: enable lenovo_fix
    - TODO: Enable secure boot here ? (Key management is also TODO)
  - `05-user-groups` - Set up user and groups. (Thats it for now)
  - `06-xorg` - Install necessary dependencies for the Xorg and i3 WM.
    - At this point, we should also install fonts. But that's TODO for now.

### Device specific notes
#### Thinkpad
 You can check full details at https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)

 - Setup Secure Boot (TODO).
 - Make sure to have sleep setting in BIOS set to Linux

### Other Notes
 - https://github.com/polybar/polybar is pretty simple to compile/install (.bin/)
 - https://aur.archlinux.org/packages/autojump/ can be used to install autojump.
 - Key management tools/flow. (TODO)
