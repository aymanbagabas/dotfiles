# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, pkgs, user, hostname, ... }:

{
  imports = [
    ../nixos.nix
    ./hardware-configuration.nix
    ./disko-config.nix
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
  };
  services.tautulli = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
  };
  services.readarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
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
  };
  # Disable for now, Calibre Server includes BonJour which interferes with
  # Avahi Daemon.
  # services.calibre-server = {
  #   enable = true;
  #   group = "wheel";
  #   user = "${user}";
  # };
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "${user}";
  };

  # Virtualisation using Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
  };

  # Searcharr
  systemd.tmpfiles.settings."10-searcharr"."/var/lib/searcharr".d = {
    inherit user;
    group = "wheel";
    mode = "0700";
  };
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      searcharr = rec {
	image = "toddrob/searcharr";
	imageFile = pkgs.dockerTools.pullImage {
	  imageName = "${image}";
	  finalImageTag = "v3.2.2";
	  imageDigest = "sha256:99290b20c772a9a346376d8725cf173171a9784f150d2dd734ef1707d101b899";
	  sha256 = "sha256-WultDmzquasFDitfTq/O6c1q5Ykxxrc9cMVfT9jw6c8=";
	  os = "linux";
	  arch = "amd64";
	};
	autoStart = true;
	extraOptions = [ "--network=host" ];
	environment = {
	  TZ = "${config.time.timeZone}";
	};
	volumes = [
	  "/var/lib/searcharr/data:/app/data"
	  "/var/lib/searcharr/logs:/app/logs"
	  "/var/lib/searcharr/settings.py:/app/settings.py"
	];
      };
    };
  };
}
