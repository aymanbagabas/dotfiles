{ user, ... }:

let
  dataDir = "/mnt/data/services";
in
{
  systemd.tmpfiles.settings."10-convertx"."${dataDir}/convertx".d = {
    inherit user;
    group = "wheel";
    mode = "0700";
  };

  virtualisation.oci-containers.containers."convertx" = {
    autoStart = true;
    image = "ghcr.io/c4illin/convertx";
    ports = [ "3000:3000" ];
    volumes = [
      "${dataDir}/convertx:/app/data"
    ];
    environment = {
      ACCOUNT_REGISTRATION = "false"; # true or false, doesn't matter for the first account (e.g. keep this to false if you only want one account)
      HTTP_ALLOWED = "true"; # setting this to true is unsafe, only set this to true locally
      ALLOW_UNAUTHENTICATED = "false"; # allows anyone to use the service without logging in, only set this to true locally
      AUTO_DELETE_EVERY_N_HOURS = "24"; # checks every n hours for files older then n hours and deletes them, set to 0 to disable
    };
  };
}
