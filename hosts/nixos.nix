{ pkgs, user, hostname, ... }:

{
  imports = [
    ./shared.nix
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.defaultUserShell = pkgs.zsh;

  # Add "@wheel" group to trusted-users.
  nix.settings.trusted-users = [ "@wheel" ];

  # Run garbage collection weekly.
  nix.gc.dates = "weekly";

  networking.hostName = hostname;

  # Enable passwordless sudo
  security.sudo.extraRules = [
    {
      users = [ "${user}" ];
      commands = [
      {
        command = "ALL";
        options = [ "NOPASSWD" ];
      }
      ];
    }
  ];

  # Enable basic programs.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.less.enable = true;

  # Common services.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      # Allow GnuPG agent forwarding.
      StreamLocalBindUnlink = "yes";
    };
  };
  services.cron.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };

  # Restart Avahi on failure.
  systemd.services.avahi-daemon = {
    unitConfig.StartLimitIntervalSec = 30;
    unitConfig.StartLimitBurst = 3;
    serviceConfig.Restart = "on-failure";
  };
}
