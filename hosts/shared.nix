{ pkgs, ... }:

{
  nix = {
    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Allow NixOS system NUR packages
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.systemPackages = with pkgs; [
    cachix
    coreutils
    git
    neovim
  ];
}
