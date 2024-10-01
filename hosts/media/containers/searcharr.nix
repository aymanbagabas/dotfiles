{
  config,
  user,
  ...
}:

let
  dataDir = "/mnt/data/services";
in
{
  systemd.tmpfiles.settings."10-searcharr"."${dataDir}/searcharr".d = {
    inherit user;
    group = "wheel";
    mode = "0700";
  };

  virtualisation.oci-containers = {
    containers = {
      searcharr = {
        image = "toddrob/searcharr";
        autoStart = true;
        extraOptions = [ "--network=host" ];
        environment = {
          TZ = "${config.time.timeZone}";
        };
        volumes = [
          "${dataDir}/searcharr/data:/app/data"
          "${dataDir}/searcharr/logs:/app/logs"
          "${dataDir}/searcharr/settings.py:/app/settings.py"
        ];
      };
    };
  };
}
