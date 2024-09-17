{ config, pkgs, isDarwin, user, ... }:

with pkgs.lib;

let pathJoin = builtins.concatStringsSep ":";
in {
  home.username = "${user}";
  home.homeDirectory = (if isDarwin then "/Users" else "/home") + "/${user}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PROJECTS = "$HOME/Source";
    EDITOR = "nvim";
    VISUAL = "nvim";

    PATH = pathJoin ([
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
      "$HOME/.npm-global/bin"
      "$HOME/.go/bin"
      "$HOME/.bin"
      "$PATH"
    ]);

    # My GPG key ID
    KEYID = "${config.programs.gpg.settings.default-key}";

    # https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
    TERMINFO_DIRS = "$TERMINFO_DIRS:$HOME/.local/share/terminfo";

    # Disable dotnet telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
  } // (optionalAttrs pkgs.stdenv.isDarwin {
    LSCOLORS = "exfxcxdxbxegedabagacad";
    CLICOLOR = "1";
  });

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG
  xdg.enable = true;
}
