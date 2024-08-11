{ config, pkgs, ... }:

let
  inherit (pkgs.lib) optionalAttrs optionalString optional concatStringsSep concatMapStrings getExe;
  homedir = "${config.home.homeDirectory}/.gnupg";
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  cfg = {
    # For more info
    # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
    pinentryPackage = with pkgs; if isDarwin then pinentry_mac else pinentry-gnome;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
    defaultCacheTtlSsh = 31536000;
    maxCacheTtlSsh = 31536000;
    enableZshIntegration = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = true;
    extraConfig = ''
    #verbose
    log-file ${homedir}/gpg-agent.log
    '';
    sshKeys = [
      # The default key doesn't need to be added.
      # Note: each key grip line need to have the flags field and a trailing
      # newline.
      ''
      # Ed25519 key added on: 2023-02-19 03:48:15
      # Fingerprints:  MD5:e0:3d:d8:df:65:37:71:81:55:64:26:04:bf:73:30:e1
      #                SHA256:1izFUbLJhlQts1tMgG4ZcXivcAx83DJdBmvSI4jK8fU
      90E6532F3492CD9E14FF1E5366371FAA7A55EDEA 0
      '' # Ayman@DESKTOP-DQ7A0U1
    ];
  };

in {

  programs.zsh.shellAliases = {
    gpg-reload-agent = "gpg-connect-agent reloadagent /bye";
    gpg-other-card = "gpg-connect-agent 'scd serialno' 'learn --force' /bye";
  };

  programs.gpg = {
    enable = true;
    homedir = homedir;
    settings = {
      default-key = "593D6EEE7871708E329619322EBA00DFFCC63351";
      default-recipient-self = true;
      use-agent = true;
      keyserver = "hkps://keys.openpgp.org";
      # Display long key IDs
      keyid-format = "0xlong";
      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;
    };
  };

  services.gpg-agent = cfg // (optionalAttrs isLinux {
    enable = true;
  });

  # From here on, this is copied from the original hm module
  # https://github.com/nix-community/home-manager/blob/9f32c66a51d05e6d4ec0dea555bbff9135749ec7/modules/services/gpg-agent.nix
  # We need this because GPG agent is not started by default on macOS and the
  # hm module does not support macOS
  home.file."${homedir}/gpg-agent.conf".text = optionalString isDarwin concatStringsSep "\n"
    (optional (cfg.enableSshSupport) "enable-ssh-support"
      ++ optional cfg.grabKeyboardAndMouse "grab"
      ++ optional (!cfg.enableScDaemon) "disable-scdaemon"
      ++ optional (cfg.defaultCacheTtl != null)
      "default-cache-ttl ${toString cfg.defaultCacheTtl}"
      ++ optional (cfg.defaultCacheTtlSsh != null)
      "default-cache-ttl-ssh ${toString cfg.defaultCacheTtlSsh}"
      ++ optional (cfg.maxCacheTtl != null)
      "max-cache-ttl ${toString cfg.maxCacheTtl}"
      ++ optional (cfg.maxCacheTtlSsh != null)
      "max-cache-ttl-ssh ${toString cfg.maxCacheTtlSsh}"
      ++ optional (cfg.pinentryPackage != null)
      "pinentry-program ${getExe cfg.pinentryPackage}"
      ++ [ cfg.extraConfig ]);

  programs.zsh.initExtra = optionalString (isDarwin && cfg.enableZshIntegration) ''
    # use gpg-agent for ssh
    # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html#Agent-Examples
	unset SSH_AGENT_PID
	if [ "''${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
      export SSH_AUTH_SOCK
    fi
    GPG_TTY="$(tty)"
    export GPG_TTY
	${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
    ${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
  '';

  # Trailing newlines are important
  home.file."${homedir}/sshcontrol".text = optionalString (isDarwin && cfg.sshKeys != null)
    ''
    # List of allowed ssh keys.  Only keys present in this file are used
    # in the SSH protocol.  The ssh-add tool may add new entries to this
    # file to enable them; you may also add them manually.  Comment
    # lines, like this one, as well as empty lines are ignored.  Lines do
    # have a certain length limit but this is not serious limitation as
    # the format of the entries is fixed and checked by gpg-agent. A
    # non-comment line starts with optional white spaces, followed by the
    # keygrip of the key given as 40 hex digits, optionally followed by a
    # caching TTL in seconds, and another optional field for arbitrary
    # flags.   Prepend the keygrip with an '!' mark to disable it.
    ''
    + concatMapStrings (s: "\n${s}") cfg.sshKeys;
}
