{
  config,
  pkgs,
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
          "${dataDir}/searcharr/data:/app/data"
          "${dataDir}/searcharr/logs:/app/logs"
          "${dataDir}/searcharr/settings.py:/app/settings.py"
        ];
      };
    };
  };
}
