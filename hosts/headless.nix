{ pkgs, ... }:

{
  imports = [
    ../modules/home.nix
    ../modules/zsh.nix
    ../modules/scripts
    ../modules/tmux
  ];
}

