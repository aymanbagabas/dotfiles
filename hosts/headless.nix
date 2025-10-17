{ pkgs, ... }:

{
  imports = [
    ../modules/home
    ../modules/scripts
    ../modules/tmux
  ];

  home.packages = with pkgs; [
    (with nur.repos.aymanbagabas; shcopy)
  ];
}

