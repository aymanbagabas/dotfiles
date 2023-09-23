# dotfiles

Ayman's (~) dotfiles

```
Colorscheme: Onedark
Shell:       zsh/pwsh
Terminal:    iTerm2/WindowsTerminal
Font:        Inconsolata + NF
```

## Dependencies

- `git` to clone the repository
- `bash` to run the bootstrap script on *nix
- `powershell` to run the bootstrap script on Windows

## Installation

Clone to `~/.dotfiles`

```sh
# On *nix
git clone https://github.com/aymanbagabas/dotfiles.git ~/.dotfiles
# On Windows PowerShell
git clone https://github.com/aymanbagabas/dotfiles.git $Env:USERPROFILE\.dotfiles
```

Or download the [tarball](https://github.com/aymanbagabas/dotfiles/archive/refs/heads/master.zip) and extract it to `~/.dotfiles`

### Unix

To install the dotfiles use `bootstrap.sh`

Use [`.vars`](./.vars) to set global variables like your name, email, and GPG
key id to use throughout the bootstrap process.

```sh
cd ~/.dotfiles
./bootstrap.sh help # show help
./bootstrap.sh packages # install required & recommended packages
./bootstrap.sh install # install the dotfiles
./bootstrap.sh bin # install local binaries
./bootstrap.sh set-shell # sets the default shell (zsh)
```

Use `-d` to `dry-run` the script without modifying your environment

### Windows

Use `bootstrap.ps1` to install the dotfiles on Windows

```powershell
cd $Env:USERPROFILE\.dotfiles
.\bootstrap.ps1 help # show help
.\bootstrap.ps1 packages # install required & recommended packages
.\bootstrap.ps1 install # install the dotfiles
```

## Recommended Software

- `zsh`
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
