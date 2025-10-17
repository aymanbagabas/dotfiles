{ pkgs, ... }:

{
  imports = [
    ../modules/home.nix
    ../modules/scripts
    ../modules/tmux
  ];

  home.packages = with pkgs; [
    (with nur.repos.aymanbagabas; shcopy)
  ];
}

