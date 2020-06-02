Installing Archlinux
====================


## Creating USB flash installation media
### MacOS
Source: https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_macOS  
Creating USB Media for installing from MacOS:
 - `diskutil list`
 - `diskutil unmountDisk /dev/diskX`
 - `dd if=/path/to/iso/file of=/dev/diskX bs=1m`
