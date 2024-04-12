{ pkgs, ... }:

{
  imports = [
    ../shared.nix
  ];

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "root" "ayman" ];
    };
  };


  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "alacritty"
      "alt-tab"
      "clipy"
      "discord"
      "docker"
      "firefox"
      "font-inconsolata-lgc"
      "font-symbols-only-nerd-font"
      "google-chrome"
      "iterm2-beta"
      "karabiner-elements"
      "kitty"
      "microsoft-remote-desktop"
      "multitouch"
      "rectangle"
      "slack"
      "spotify"
      "syncthing"
      "telegram"
      "the-unarchiver"
      "vmware-fusion"
      "xquartz"
    ];
  };
}
