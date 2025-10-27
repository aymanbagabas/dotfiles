{ pkgs, ... }:

let 
  dir = "/mnt/data/services/searcharr";
  lib = pkgs.lib;
in {
  virtualisation.oci-containers.containers."searcharr" = {
    image = "toddrob/searcharr:v3";
    environment = {
      "TZ" = "America/New_York";
    };
    volumes = [
      "${dir}/data:/app/data"
      "${dir}/logs:/app/logs"
      "${dir}/settings.py:/app/settings.py"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=searcharr"
        "--network-alias=searcharr"
        "--network=services"
    ];
  };
  systemd.services."docker-searcharr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_searcharr_data.service"
    ];
    requires = [
      "docker-volume-media_searcharr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  systemd.services."docker-volume-media_searcharr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ls ${dir} || mkdir -p ${dir}
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
}
