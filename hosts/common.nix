# This defines common home-manager configuration for all users.
{ config, pkgs, isDarwin, ... }:

let
  inherit (pkgs) lib;
in {
  imports = [
    ../modules/git.nix
    ../modules/gpg.nix
    ../modules/neovim
    ../modules/shell.nix
    ../modules/ssh.nix
    ../modules/tmux
    ../modules/xresources.nix

    # Dev
    ../modules/go.nix
    ../modules/npm.nix

    # Applications (GUI)
    ../modules/alacritty.nix
    ../modules/ghostty.nix
    ../modules/kitty.nix

    ../modules/nixpkgs.nix
  ];

  xdg.configFile = lib.mkIf (isDarwin) {
    # Need to symlink karabiner.json to the correct location
    # https://github.com/nix-community/home-manager/issues/2085
    "karabiner/karabiner.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/karabiner.json";
  };
}
