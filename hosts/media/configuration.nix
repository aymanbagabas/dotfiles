# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  user,
  hostname,
  ...
}:

with pkgs.lib;

let
  dataDir = "/mnt/data/services";
  calibreLibrary = "/mnt/share/autopirate/Books";
  mkService = name: {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    dataDir = "${dataDir}/${name}";
  };
in
{
  imports = [
    ../../services
    ../autoupgrade.nix
    ../nixos.nix
    ./disko-config.nix
    ./docker-compose.nix
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable serial console display on serial=0.
  # We use this because there's a bug when passing through Intel iGPU to a VM
  # with a display.
  #  [drm:i915_gem_init_stolen [i915]] *ERROR* conflict detected with stolen region
  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  # Make initial login passwordless.
  # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.initialHashedPassword
  users.users.root.initialHashedPassword = "";
  users.users.${user} = {
    initialHashedPassword = "";
    extraGroups = [ "docker" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.hostName = hostname;

  # Configure a static IP for the P2P Nas connection.
  networking.interfaces."ens19" = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.1.1.3";
      prefixLength = 24;
    }];
  };

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-gpu-tools
    vpl-gpu-rt
    libvdpau-va-gl
  ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  # Enable OpenSSH X11 forwarding.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };

  # Virtualisation using Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
  };
}
