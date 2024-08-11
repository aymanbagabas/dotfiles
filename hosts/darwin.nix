# This is a nix-darwin configuration module.
{ user, config, ... }:

{
  imports = [
    ./shared.nix
  ];

  # nix-darwin has an "interval" option instead of "dates".
  nix.gc.interval = { Weekday = 0; Hour = 0; Minute = 0; }; # 0th day of every week

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  services.nix-daemon.enable = true;

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
      "alt-tab"
      "clipy"
      "docker"
      "firefox"
      "google-chrome"
      "microsoft-remote-desktop"
      "multitouch"
      "raycast"
      "tailscale"
      "the-unarchiver"
      "vmware-fusion"
      "whatsapp"
    ];
  };

  # gpg-agent is handled by home-manager
  #programs.gnupg.agent.enable = true;
  #programs.gnupg.agent.enableSSHSupport = true;

  # Karabiner Elements
  services.karabiner-elements.enable = true;

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "bottom";
      };
      trackpad = {
        Clicking = true;
      };
      CustomUserPreferences = {
        "com.googlecode.iterm2.plist" = {
          # Specify the preferences directory
          # Cannot be a nix store link
          # https://github.com/nix-community/home-manager/issues/2085
          PrefsCustomFolder = "${config.users.users.${user}.home}/.dotfiles/users/${user}";
          # Tell iTerm2 to use the custom preferences in the directory
          LoadPrefsFromCustomFolder = true;
        };
      };
    };
  };
}
