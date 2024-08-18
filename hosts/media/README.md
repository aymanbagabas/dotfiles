# media

This host configurations bootstrap the _media_ QEMU virtual machine. This VM contains media related services such as Plex, Servarr applications, etc. It uses [_disko_](https://github.com/nix-community/disko) to create partitions and file systems.

## Installation

After booting up NixOS run the following:

```sh
sudo -i
nix-shell -p git nixVersions.latest # Remove if you want to use stable instead
git clone https://github.com/aymanbagabas/dotfiles.git /mnt/etc/nixos
cd /mnt/etc/nixos
nixos-install --flake .#media --impure
```
