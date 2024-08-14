# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, pkgs, pkgs-unstable, user, hostname, ... }:

{
  imports = [
    ../nixos.nix
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  environment.systemPackages = [ pkgs.cifs-utils ];

  networking.hostName = hostname;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

# Enable OpenSSH X11 forwarding.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
  };

  services.plex = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.plex;
  };
  services.tautulli = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.tautulli;
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.sonarr;
  };
  services.readarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.readarr;
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.radarr;
  };
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
    package = pkgs-unstable.prowlarr;
  };
  services.calibre-server = {
    enable = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.calibre;
  };
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
    package = pkgs-unstable.calibre-web;
  };
}
