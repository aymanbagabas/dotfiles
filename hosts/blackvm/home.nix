{ sops-nix, ... }:

{
  imports = [
    sops-nix.homeManagerModules.sops
    ../modules/home.nix
    ../modules/pkgs.nix
    ./common.nix
  ];
}
