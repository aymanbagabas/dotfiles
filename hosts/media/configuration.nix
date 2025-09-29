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
    ./containers
    ./disko-config.nix
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
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

  environment.systemPackages = [ pkgs.cifs-utils ];

  networking.hostName = hostname;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  # Enable OpenSSH X11 forwarding.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };

  # enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      # intel-media-sdk # QSV up to 11th gen
    ];
  };

  # services.jellyfin = mkService "jellyfin";
  # services.plex = mkService "plex";
  # services.tautulli = mkService "tautulli";
  # services.sonarr = mkService "sonarr";
  # services.readarr = mkService "readarr";
  # services.radarr = mkService "radarr";
  # services.bazarr = mkService "bazarr";
  # services.prowlarr = mkService "prowlarr";
  # services.calibre-web = mkService "calibre-web" // {
  #   listen.ip = "0.0.0.0";
  #   options.calibreLibrary = "${calibreLibrary}";
  # };
  # services.calibre-server = {
  #   enable = true;
  #   openFirewall = true;
  #   group = "wheel";
  #   user = "${user}";
  #   libraries = [ "${calibreLibrary}" ];
  #   extraFlags = [
  #     "--disable-use-bonjour" # Disable Bonjour because it interferes with Avahi
  #   ];
  #   auth = {
  #     enable = true;
  #     userDb = "/mnt/data/services/calibre-server/users.sqlite";
  #   };
  # };

  # Sonarr uses an EOL dotnet version, so we need to use the old runtime.
  # TODO: Update Sonarr to use a newer version of dotnet.
  # See https://github.com/Sonarr/Sonarr/pull/7443
  # See https://github.com/NixOS/nixpkgs/issues/360592
  # nixpkgs.config.permittedInsecurePackages = [
  #   "aspnetcore-runtime-6.0.36"
  #   "aspnetcore-runtime-wrapped-6.0.36"
  #   "dotnet-sdk-6.0.428"
  #   "dotnet-sdk-wrapped-6.0.428"
  # ];

  # Virtualisation using Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
  };
}
