# This is a nix-darwin configuration module.
{
  user,
  hostname,
  config,
  ...
}:

{
  imports = [ ./shared.nix ];

  # nix-darwin system state version.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 5;

  # nix-darwin has an "interval" option instead of "dates".
  nix.gc.interval = {
    Weekday = 0;
    Hour = 0;
    Minute = 0;
  }; # 0th day of every week

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  services.nix-daemon = {
    enable = true;
    enableSocketListener = true;
  };

  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;

  # We don't need this workaround anymore since we're using nix-darwin socket
  # listener to manage the daemon.
  # programs.zsh.shellInit = ''
  #   # Nix
  #   if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  #     . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  #   fi
  #   # End Nix
  # '';

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
      "google-chrome"
      "iterm2"
      "karabiner-elements"
      "kitty"
      "microsoft-remote-desktop"
      "multitouch"
      "raycast"
      "rectangle"
      "slack"
      "spotify"
      "tailscale"
      "telegram-desktop"
      "the-unarchiver"
      "vmware-fusion"
      "wezterm@nightly"
      "whatsapp"
      "xquartz"
    ];
    masApps = {
      "AdBlock Pro" = 1018301773;
      "LanguageTool" = 1534275760;
      "Vimari" = 1480933944;
    };
  };

  # gpg-agent is handled by home-manager
  #programs.gnupg.agent.enable = true;
  #programs.gnupg.agent.enableSSHSupport = true;

  # Karabiner Elements
  #services.karabiner-elements.enable = true; # use homebrew instead

  networking = {
    hostName = hostname;
    localHostName = hostname;
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "bottom";
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/System/Applications/Messages.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Contacts.app"
          "/System/Applications/Reminders.app"
          "/System/Applications/Notes.app"
          "/Applications/Slack.app"
          "/Applications/Discord.app"
          "/Applications/Ghostty.app"
          "/System/Applications/App Store.app"
          "/System/Applications/System Settings.app"
          "/Applications/Spotify.app"
        ];
      };
      trackpad = {
        Clicking = true;
      };
      finder = {
        FXPreferredViewStyle = "Nlsv";
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };
      NSGlobalDomain = {
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        "com.apple.mouse.tapBehavior" = 1;
      };
      CustomUserPreferences = {
        "com.googlecode.iterm2.plist" = {
          # Specify the preferences directory
          # Cannot be a nix store link
          # https://github.com/nix-community/home-manager/issues/2085
          PrefsCustomFolder = "${config.users.users.${user}.home}/.dotfiles/modules";
          # Tell iTerm2 to use the custom preferences in the directory
          LoadPrefsFromCustomFolder = true;
        };
        "com.apple.Safari" = {
          IncludeInternalDebugMenu = true;
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          ShowFullURLInSmartSearchField = true;
          AutoOpenSafeDownloads = false;
          HomePage = "";
          AutoFillCreditCardData = false;
          AutoFillFromAddressBook = false;
          AutoFillMiscellaneousForms = false;
          AutoFillPasswords = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
          AlwaysRestoreSessionAtLaunch = 1;
          ExcludePrivateWindowWhenRestoringSessionAtLaunch = 1;
          ShowBackgroundImageInFavorites = 0;
          ShowFrequentlyVisitedSites = 1;
          ShowHighlightsInFavorites = 1;
          ShowPrivacyReportInFavorites = 1;
          ShowRecentlyClosedTabsPreferenceKey = 1;
        };
      };
    };
  };
}
