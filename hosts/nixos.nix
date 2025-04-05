{
  pkgs,
  user,
  hostname,
  ...
}:

{
  imports = [ ./shared.nix ];

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
  nixpkgs.config = import ../modules/nixpkgs-config.nix;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable passwordless sudo
  security.sudo.wheelNeedsPassword = false;

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

  programs.htop.enable = true;
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

  # Use networkd instead of legacy script-based system.
  networking.useNetworkd = true;

  # Enable mDNS using systemd-networkd.
  systemd.network.networks."*".networkConfig.MulticastDNS = true;
  # Ensue that the link is up before starting the service.
  systemd.network.links."*".linkConfig.RequiredForOnline = true;
  # # Enable mDNS for systemd-resolved.
  services.resolved = {
    extraConfig = ''
      MulticastDNS=yes
    '';
    domains = [
      "local"
    ];
    enable = true;
  };

  # Open port 5353 for mDNS.
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
