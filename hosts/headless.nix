{ pkgs, ... }:

{
  imports = [
    ../modules/direnv.nix
    ../modules/home.nix
    ../modules/nixpkgs.nix
    ../modules/scripts
    ../modules/zsh.nix
  ];

  home.packages = with pkgs; [
    (with nur.repos.aymanbagabas; shcopy)
  ];
}

