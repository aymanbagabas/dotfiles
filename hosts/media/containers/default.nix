{ pkgs, config, user, ... }:
let
  dataDir = "/mnt/data/services";
  libDir = "/mnt/share/autopirate";
  timezone = "${config.time.timeZone}";
  networkName = "services";
  puid = toString config.users.users."${user}".uid;
  pgid = toString config.users.groups."wheel".gid;
  mkTmpfs = name: {
    systemd.tmpfiles.settings."10-${name}"."${dataDir}/${name}".d = {
      inherit user;
      group = "wheel";
      mode = "0700";
    };
  };
in {
  imports = [
    ./convertx.nix
    ./watchtower.nix
  ];

  # Create data directories with correct permissions.
  # We use tmpfiles.d to create these directories at boot time with the
  # correct permissions.
  systemd.tmpfiles.settings = {
    inherit (mkTmpfs "prowlarr") ;
    inherit (mkTmpfs "sonarr") ;
    inherit (mkTmpfs "bazarr") ;
    inherit (mkTmpfs "radarr") ;
    inherit (mkTmpfs "readarr") ;
    inherit (mkTmpfs "searcharr") ;
    inherit (mkTmpfs "calibre-web") ;
    inherit (mkTmpfs "calibre-server") ;
    inherit (mkTmpfs "plex") ;
    inherit (mkTmpfs "tautulli") ;
  };

  virtualisation.oci-containers = {
    # Use docker as a backend.
    backend = "docker";
    containers = {
      "prowlarr" = {
        autoStart = true;
        hostname = "prowlarr";
        image = "ghcr.io/linuxserver/prowlarr:latest";
        ports = [ "9696:9696" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/prowlarr:/config"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
      "sonarr" = {
        autoStart = true;
        hostname = "sonarr";
        image = "ghcr.io/linuxserver/sonarr:latest";
        ports = [ "8989:8989" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/sonarr:/config"
          "${libDir}/Tv:/tv"
          "${libDir}/Etc/downloads:/downloads"
          "${libDir}/Etc/torrents:/data"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
      "bazarr" = {
        autoStart = true;
        hostname = "bazarr";
        image = "ghcr.io/linuxserver/bazarr:latest";
        ports = [ "6767:6767" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/bazarr:/config"
          "${libDir}/Tv:/tv"
          "${libDir}/Movies:/movies"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
      "radarr" = {
        autoStart = true;
        hostname = "radarr";
        image = "ghcr.io/linuxserver/radarr:latest";
        ports = [ "7878:7878" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/radarr:/config"
          "${libDir}/Movies:/movies"
          "${libDir}/Etc/downloads:/downloads"
          "${libDir}/Etc/torrents:/data"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
      "readarr" = {
        autoStart = true;
        hostname = "readarr";
        image = "ghcr.io/hotio/readarr:latest";
        ports = [ "8787:8787" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/readarr:/config"
          "${libDir}/Books:/books"
          "${libDir}/Etc/downloads:/downloads"
          "${libDir}/Etc/torrents:/data"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
      "searcharr" = {
        autoStart = true;
        hostname = "searcharr"; 
        image = "toddrob/searcharr";
        environment = {
          TZ = timezone;
        };
        networks = [ "services" ];
        volumes = [
          "${dataDir}/searcharr/data:/app/data"
          "${dataDir}/searcharr/logs:/app/logs"
          "${dataDir}/searcharr/settings.py:/app/settings.py"
        ];
      };
      "calibre-web" = {
        autoStart = true;
        hostname = "calibre-web";
        image = "ghcr.io/linuxserver/calibre-web:latest";
        ports = [ "8083:8083" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/calibre-web:/config"
          "${libDir}/Books:/books"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
      "calibre-server" = {
        autoStart = true;
        hostname = "calibre-server";
        image = "ghcr.io/linuxserver/calibre:latest";
        ports = [ "8080:8080" "8081:8081" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/calibre-server:/config"
          "${libDir}/Books:/books"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };

      # "jellyfin" = {
      #   autoStart = true;
      #   image = "ghcr.io/linuxserver/jellyfin:latest";
      #   ports = [
      #     "8096:8096"
      #     "8920:8920"
      #     "7359:7359/udp"
      #     "1900:1900/udp"
      #   ];
      #   volumes = [
      #     "${dataDir}/jellyfin:/config"
      #     "${libDir}/Tv:/tv"
      #     "${libDir}/Movies:/movies"
      #     "${libDir}/Music:/music"
      #   ];
      #   devices = [ "/dev/dri:/dev/dri" ]; # vaapi
      #   environment = {
      #     PUID = "${puid}";
      #     PGID = "${pgid}";
      #     TZ = timezone;
      #     UMASK_SET = 022; #optional
      #     JELLYFIN_PublishedServerUrl = "https://jellyfin.ayman.ba:8920/"; #optional
      #   };
      # };

      "plex" = {
        autoStart = true;
        hostname = "plex";
        image = "ghcr.io/linuxserver/plex:latest";
        ports = [
          "32400:32400"
          "3005:3005"
          "8324:8324"
          "32469:32469"
          "1900:1900/udp"
          "32410:32410/udp"
          "32412:32412/udp"
          "32413:32413/udp"
          "32414:32414/udp"
        ];
        volumes = [
          "${dataDir}/plex:/config"
          "${libDir}/Tv:/tv"
          "${libDir}/Movies:/movies"
          "${libDir}/Music:/music"
        ];
        networks = [ networkName ];
        devices = [ "/dev/dri:/dev/dri" ]; # vaapi
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
          UMASK_SET = "022"; #optional
          PLEX_CLAIM = "claim-TFbWN86ovmwzCsaD_oru"; #optional
          ADVERTISE_IP = "https://plex.ayman.ba:32400/"; #optional
          VERSION = "docker"; # don't update automatically, updates are handled by watchtower
        };
      };
      "tautulli" = {
        autoStart = true;
        hostname = "tautulli";
        image = "ghcr.io/linuxserver/tautulli:latest";
        ports = [ "8181:8181" ];
        networks = [ networkName ];
        volumes = [
          "${dataDir}/tautulli:/config"
        ];
        environment = {
          PUID = "${puid}";
          PGID = "${pgid}";
          TZ = timezone;
        };
      };
    };
  };

  # Networks
  systemd.services."docker-network-${networkName}" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f ${networkName}";
    };
    script = ''
      docker network inspect ${networkName} || docker network create ${networkName}
    '';
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
  };
}

# let
#   dataDir = "/mnt/data/services";
# in
# {
#   systemd.tmpfiles.settings."10-convertx"."${dataDir}/convertx".d = {
#     inherit user;
#     group = "wheel";
#     mode = "0700";
#   };
#
#   virtualisation.oci-containers.containers."convertx" = {
#     autoStart = true;
#     image = "ghcr.io/c4illin/convertx";
#     ports = [ "3000:3000" ];
#     volumes = [
#       "${dataDir}/convertx:/app/data"
#     ];
#     environment = {
#       ACCOUNT_REGISTRATION = "false"; # true or false, doesn't matter for the first account (e.g. keep this to false if you only want one account)
#       HTTP_ALLOWED = "true"; # setting this to true is unsafe, only set this to true locally
#       ALLOW_UNAUTHENTICATED = "false"; # allows anyone to use the service without logging in, only set this to true locally
#       AUTO_DELETE_EVERY_N_HOURS = "24"; # checks every n hours for files older then n hours and deletes them, set to 0 to disable
#     };
#   };
# }
