{ pkgs, user, isDarwin, ... }:

{
  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.${user} = {
    name = "${user}";
    home = (if isDarwin then "/Users" else "/home") + "/${user}";
    shell = pkgs.zsh;
  };

  nix = {
    package = pkgs.nix;
    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [ "root" "${user}" ];
    };
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
