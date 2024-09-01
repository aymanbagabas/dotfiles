
{ pkgs, dotfiles, ghostty, isDarwin, isLinux, isHeadless, ... }:

let
  inherit (pkgs) lib;
in {
  home.packages = with pkgs; with pkgs.nodePackages_latest; [
    _1password
    age
    curl
    fd
    fortune
    gnused
    htop
    jq
    p7zip
    ripgrep
    tz
    wget
    yarn
    zoxide

    # Fonts
    inconsolata-lgc
    jetbrains-mono
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    # Dev tools
    nodejs
    svu
    yarn

    # DevOps
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ] ++ (with ghostty; lib.optionals (!isHeadless) [
    # Applications (GUI)
    alacritty
    obsidian
    telegram-desktop
  ]) ++ (lib.optionals (!isHeadless && isDarwin) [
    rectangle
    xquartz
  ]) ++ (lib.optionals (!isHeadless && isLinux) [
    _1password-gui
    discord
    kitty
    slack
    spotify
    tailscale # We use Homebrew for macOS
    ghostty.packages.${lib.system}.default # Ghostty is only available on Linux
  ]);

  home.sessionVariables = {
    # tz timezone list
    TZ_LIST = builtins.readFile "${dotfiles}/vars/tz_list";
  };
}
