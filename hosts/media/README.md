# media

This host configurations bootstrap the _media_ QEMU virtual machine. This VM contains media related services such as Plex, Servarr applications, etc. It uses [_disko_](https://github.com/nix-community/disko) to create partitions and file systems.

## Installation

1. Set up and format the disk(s) using
   [Disko](https://github.com/nix-community/disko/blob/master/docs/quickstart.md):

```sh
sudo -i
curl https://raw.githubusercontent.com/aymanbagabas/dotfiles/master/hosts/$HOST/disko-config.nix -o /tmp/disko-config.nix # Make sure to replace $HOST with the targeted host name.
cd /tmp
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko-config.nix
```

2. Boot up NixOS run the following:

```sh
sudo -i
nix-shell -p git nixVersions.latest # Remove if you want to use stable instead
git clone https://github.com/aymanbagabas/dotfiles.git /mnt/etc/nixos
cd /mnt/etc/nixos
nixos-install --flake .#media --impure
```
