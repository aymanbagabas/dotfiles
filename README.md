# dotfiles

Ayman's (~) Nix and NixOS dotfiles
It uses nixOS, home-manager, and nix-darwin.

```
Colorscheme: Onedark
Shell:       zsh/pwsh
Terminal:    Ghostty/iTerm2/WindowsTerminal
Font:        Inconsolata LGC + NF
```

## Install Nix

This is only necessary when you're _not_ running NixOS.

```sh
# On MacOS
# Use Determinate Systems Nix installer
# I find this a more stable and reliable installation for MacOS
# You can also use the official Nix installer
# sh <(curl -L https://nixos.org/nix/install)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# Install Homebrew (Optional)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add the fonts tap (Optional)
brew tap homebrew/cask-fonts
# Change the hostname and machine name
# Go to System Settings and change both the machine name and Sharing hostname
# to the machine hostname.
# You also want to set the hostname using `scutil`
sudo scutil --set HostName <hostname>

# On Linux
sh <(curl -L https://nixos.org/nix/install) --daemon
```

See [Nix download](https://nixos.org/download/) page for more info.

## enable flakes

This dotfiles use Nix Flakes, make sure it's enabled on your system.

Using NixOS, add the following to your `configuration.nix`:

```nix
nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
};
```

Otherwise:

```sh
mkdir -p "$HOME/.config/nix"
echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
```

## Management

To apply or update the dotfiles and configurations, first make sure you have
cloned the repository:

```sh
git clone https://github.com/aymanbagabas/dotfiles.git ~/.dotfiles
```

Now you can use `nix develop` to run the commands in development shell.

```sh
# apply dotfiles
nix develop .#default --command dot-apply
# sync with latest
nix develop .#default --command dot-sync
```

## Tips

### Fix Tmux Colors on MacOS

See [this gist](https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95).

## Screenshots

Neovim:

![neovim](https://github.com/aymanbagabas/dotfiles/assets/3187948/37ba40e4-52eb-49a0-9f9d-a5df36f22530)
