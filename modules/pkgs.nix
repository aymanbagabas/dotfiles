
{ pkgs, inputs, isDarwin, isLinux, isHeadless, ... }:

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
    (with nur.repos.caarlos0; svu)
    nodejs
    yarn

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
    obsidian
    slack
    spotify
    syncthing
    telegram-desktop
  ]) ++ (lib.optionals (!isHeadless && isDarwin) [
    iterm2
    rectangle
    xquartz
  ]) ++ (lib.optionals (!isHeadless && isLinux) [
    tailscale # We use Homebrew for macOS
    inputs.ghostty.packages.${lib.system}.default # Ghostty is only available on Linux
  ]);
}
