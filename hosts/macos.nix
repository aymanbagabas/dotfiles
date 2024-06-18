{ pkgs, user, ... }:

rec {
  imports = [
    ./shared.nix
  ];

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "root" "${user}" ];
    };
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
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
      "alt-tab"
      "clipy"
      "docker"
      "firefox"
      "google-chrome"
      "microsoft-remote-desktop"
      "multitouch"
      "raycast"
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
          PrefsCustomFolder = "${users.users.${user}.home}/.dotfiles/users/${user}";
          # Tell iTerm2 to use the custom preferences in the directory
          LoadPrefsFromCustomFolder = true;
        };
      };
    };
  };
}
