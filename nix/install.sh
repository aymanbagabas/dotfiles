#!/bin/sh

# ponytail: user-level nix.conf; caches honored only if you're a trusted-user
# (Determinate installer sets this). Move to /etc/nix/nix.conf if that changes.
link_file nix.conf ~/.config/nix/nix.conf
