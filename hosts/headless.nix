{ pkgs, ... }:

{
  imports = [
    ../modules/direnv.nix
    ../modules/gpg.nix
    ../modules/home.nix
    ../modules/nixpkgs.nix
    ../modules/scripts
    ../modules/tmux
    ../modules/zsh.nix
  ];

  home.packages = with pkgs; [
    (with nur.repos.aymanbagabas; shcopy)
  ];
}

