{ pkgs, pkgs-unstable, modulesPath, hostname, user, ... }:

{
  imports = [
    ../nixos.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../autoupgrade.nix
  ];

  proxmoxLXC = {
    privileged = false;
    manageHostName = true;
  };

  # Make initial login passwordless.
  # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.initialHashedPassword
  users.users.root.initialHashedPassword = "";
  users.users.${user}.initialHashedPassword = "";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.useNetworkd = true;
  networking.hostName = hostname;
  # Enable mDNS firewall rules.
  networking.firewall.allowedUDPPorts = [ 5353 ];

  # Use networkd mDNS and LLMNR.
  systemd.network = {
    enable = true;
    networks."10-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        MulticastDNS = true;
      };
      linkConfig = {
        Multicast = true;
      };
    };
  };

  # Enable resolved mDNS
  services.resolved = {
    extraConfig = ''
      MulticastDNS=true
    '';
  };
}
