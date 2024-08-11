# Here we define MacOS specific home-manager configuration and modules.
{ ... }:
{
  imports =  [
    ../modules/home.nix
    ../modules/pkgs.nix
    ./common.nix
  ];
}
