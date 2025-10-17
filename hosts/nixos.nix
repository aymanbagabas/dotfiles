{
  pkgs,
  user,
  hostname,
  ...
}:

let
  mdnsNetworkNames = [
    "99-ethernet-default-dhcp"
    "99-wireless-client-dhcp"
  ];
in
{
  imports = [ ./shared.nix ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
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

  environment.systemPackages = with pkgs; [
    cifs-utils
    gnupg
    (with nur.repos.aymanbagabas; shcopy)
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

  # Enable Tailscale. Run `tailscale up` to authenticate.
  services.tailscale.enable = true;

  # Use networkd instead of legacy script-based system.
  networking.useNetworkd = true;

  # Enable mDNS using systemd-networkd.
  systemd.network.networks = builtins.listToAttrs (
    builtins.map (x: {
      name = x;
      value = {
        networkConfig = {
          # Enable mDNS for systemd-resolved.
          MulticastDNS = true;
        };
        linkConfig = {
          # Ensure that the network is up.
          RequiredForOnline = true;
        };
      };
    }) mdnsNetworkNames
  );
  services.resolved = {
    extraConfig = ''
      MulticastDNS=yes
      LLMNR=no
    '';
    domains = [
      # Add .local to the list of search domains.
      "local"
    ];
    enable = true;
  };

  # Open port 5353 for mDNS.
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
