{ config, pkgs, ... }:

let
  homedir = "${config.home.homeDirectory}/.gnupg";
  isDarwin = pkgs.stdenv.isDarwin;
  defaultKey = "593D6EEE7871708E329619322EBA00DFFCC63351";

in
{

  disabledModules = [
    # We're using our own gpg-agent module until the upstream one is fixed.
    # See https://github.com/nix-community/home-manager/issues/3864#issuecomment-2377072254
    # See https://github.com/nix-community/home-manager/pull/5901
    "services/gpg-agent.nix"
  ];

  imports = [
    ./gpg-agent.nix
    ./gpg-auto-import.nix
  ];

  programs.zsh.shellAliases = {
    gpg-reload-agent = "gpg-connect-agent reloadagent /bye";
    gpg-other-card = "gpg-connect-agent 'scd serialno' 'learn --force' /bye";
  };

  programs.gpg = {
    enable = true;
    homedir = homedir;
    autoImport = {
      keys = [ defaultKey ];
    };
    settings = {
      default-key = defaultKey;
      default-recipient-self = true;
      use-agent = true;
      keyserver = "hkps://keys.openpgp.org";
      # Display long key IDs
      keyid-format = "0xlong";
      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;
    };
  };

  services.gpg-agent = {
    enable = true;

    # For more info
    # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
    pinentryPackage = with pkgs; if isDarwin then pinentry_mac else pinentry-tty;
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
}
