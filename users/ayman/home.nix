{ config, pkgs, inputs, currentSystem, isDarwin, isLinux, isHeadless, ... }:

let
  inherit (pkgs) lib;

in {
  home.username = "ayman";
  home.homeDirectory = (if isDarwin then "/Users" else "/home") + "/ayman";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PROJECTS = "$HOME/Source";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG
  xdg.enable = true;

  home.packages = with pkgs; with pkgs.nodePackages_latest; [
    _1password
    age
    curl
    fd
    fortune
    htop
    jq
    p7zip
    ripgrep
    wget
    yarn
    zoxide

    # Fonts
    inconsolata-lgc
    jetbrains-mono

    # Dev tools
    go
    nodejs

    # DevOps
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ] ++ (with inputs; lib.optionals (!isHeadless) [
    # Applications (GUI)
    _1password-gui
    alacritty
    discord
    kitty
    slack
    spotify
    syncthing
    tailscale
    telegram-desktop
  ]) ++ (lib.optionals (!isHeadless && isDarwin) [
    iterm2
    rectangle
    xquartz
  ]) ++ (lib.optionals (!isHeadless && isLinux) [
    ghostty.packages.${currentSystem}.default # Ghostty is only available on Linux
  ]);

  imports = [
    ./git.nix
    ./gpg.nix
    ./shell.nix
    ./tmux
    ./xresources.nix

    # Applications (GUI)
    ./alacritty.nix
    ./ghostty.nix
  ];

  xdg.configFile = lib.mkIf (isDarwin) {
    # Need to symlink karabiner.json to the correct location
    # https://github.com/nix-community/home-manager/issues/2085
    "karabiner/karabiner.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/users/ayman/karabiner.json";
  };
}
