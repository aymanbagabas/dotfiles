{ pkgs, hostname, ... }:

let
  inherit (pkgs) lib;
  isDarwin = pkgs.stdenv.isDarwin;
  isDesktop = hostname == "Aymans-MBP";
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
  ] ++ (lib.optionals isDesktop [
    # Applications
    _1password
    _1password-gui
    alacritty
    discord
    kitty
    rectangle
    slack
    spotify
    syncthing
    tailscale
    telegram-desktop
  ]) ++ (lib.optionals isDarwin [
    iterm2
  ]);

  imports = [
    ./git.nix
    ./gpg.nix
    ./shell.nix
    ./tmux
  ];

  xdg.configFile = {
    "ghostty/config".source = ./ghostty.conf;
  } // lib.mkIf (isDarwin) {
    "karabiner/karabiner.json".source = ./karabiner.json;
  };
}
