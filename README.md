# dotfiles

Ayman's (~) dotfiles

## Dependencies

- `git` to clone the repository
- `bash` to run the bootstrap script
- `sudo` to run commands as root

## Installation

To install the dotfiles use `bootstrap.sh`

Use [`.vars`](./.vars) to set global variables like your name, email, and GPG
key id to use throughout the bootstrap process.

```sh
git clone https://github.com/aymanbagabas/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh help # show help
./bootstrap.sh packages # install required & recommended packages
./bootstrap.sh install # install the dotfiles
./bootstrap.sh bin # install local binaries
```

Use `-d` to `dry-run` the script without modifying your environment

## Recommended Software

- `difftastic`
- `tig`
- `tmux`
- `neovim`
- `fzf`
- `ripgrep`
- `gnupg`
- `exa`
- `direnv`
- `zoxide`
- `bat`
- `gh`
- `hub`
- `htop`
- `jq`
- `source-highlight`

## Screenshots

Neovim:

![neovim](https://github.com/aymanbagabas/dotfiles/assets/3187948/37ba40e4-52eb-49a0-9f9d-a5df36f22530)
