# Auto-generated using compose2nix v0.3.3-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."backup-bazarr" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/bazarr:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_bazarr_data:/backup/bazarr:ro"
    ];
    dependsOn = [
      "bazarr"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-bazarr"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-bazarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_bazarr_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_bazarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-calibre-server" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/calibre-server:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_calibre_server_data:/backup/calibre-server:ro"
    ];
    dependsOn = [
      "calibre-server"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-calibre-server"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-calibre-server" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_calibre_server_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_calibre_server_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-calibre-web" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/calibre-web:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_calibre_web_data:/backup/calibre-web:ro"
    ];
    dependsOn = [
      "calibre-web"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-calibre-web"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-calibre-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_calibre_web_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_calibre_web_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-plex" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/plex:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_plex_data:/backup/plex:ro"
    ];
    dependsOn = [
      "plex"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-plex"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-plex" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_plex_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_plex_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-prowlarr" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/prowlarr:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_prowlarr_data:/backup/prowlarr:ro"
    ];
    dependsOn = [
      "prowlarr"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-prowlarr"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_prowlarr_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_prowlarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-radarr" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/radarr:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_radarr_data:/backup/radarr:ro"
    ];
    dependsOn = [
      "radarr"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-radarr"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_radarr_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_radarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-readarr" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/readarr:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_readarr_data:/backup/readarr:ro"
    ];
    dependsOn = [
      "readarr"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-readarr"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-readarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_readarr_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_readarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-searcharr" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/searcharr:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_searcharr_data:/backup/searcharr:ro"
    ];
    dependsOn = [
      "searcharr"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-searcharr"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-searcharr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_searcharr_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_searcharr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-sonarr" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/sonarr:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_sonarr_data:/backup/sonarr:ro"
    ];
    dependsOn = [
      "sonarr"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-sonarr"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_sonarr_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_sonarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."backup-tautulli" = {
    image = "offen/docker-volume-backup:v2";
    environment = {
      "BACKUP_CRON_EXPRESSION" = "@monthly";
      "BACKUP_RETENTION_DAYS" = "90";
    };
    volumes = [
      "/mnt/share/backups/services/tautulli:/archive:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "media_tautulli_data:/backup/tautulli:ro"
    ];
    dependsOn = [
      "tautulli"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backup-tautulli"
      "--network=media_default"
    ];
  };
  systemd.services."docker-backup-tautulli" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
      "docker-volume-media_tautulli_data.service"
    ];
    requires = [
      "docker-network-media_default.service"
      "docker-volume-media_tautulli_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."bazarr" = {
    image = "ghcr.io/linuxserver/bazarr:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/mnt/share/autopirate/Movies:/movies:rw"
      "/mnt/share/autopirate/Tv:/tv:rw"
      "media_bazarr_data:/config:rw"
    ];
    ports = [
      "6767:6767/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=bazarr"
      "--network-alias=bazarr"
      "--network=services"
    ];
  };
  systemd.services."docker-bazarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_bazarr_data.service"
    ];
    requires = [
      "docker-volume-media_bazarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."calibre-server" = {
    image = "ghcr.io/linuxserver/calibre:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/mnt/share/autopirate/Books:/books:rw"
      "media_calibre_server_data:/config:rw"
    ];
    ports = [
      "8080:8080/tcp"
      "8081:8081/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=calibre-server"
      "--network-alias=calibre-server"
      "--network=services"
    ];
  };
  systemd.services."docker-calibre-server" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_calibre_server_data.service"
    ];
    requires = [
      "docker-volume-media_calibre_server_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."calibre-web" = {
    image = "ghcr.io/linuxserver/calibre-web:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/mnt/share/autopirate/Books:/books:rw"
      "media_calibre_web_data:/config:rw"
    ];
    ports = [
      "8083:8083/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=calibre-web"
      "--network-alias=calibre-web"
      "--network=services"
    ];
  };
  systemd.services."docker-calibre-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_calibre_web_data.service"
    ];
    requires = [
      "docker-volume-media_calibre_web_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."plex" = {
    image = "ghcr.io/linuxserver/plex:latest";
    environment = {
      "ADVERTISE_IP" = "https://plex.ayman.ba:32400/";
      "PGID" = "1";
      "PLEX_CLAIM" = "claim-TFbWN86ovmwzCsaD_oru";
      "PUID" = "1000";
      "TZ" = "America/New_York";
      "UMASK_SET" = "022";
      "VERSION" = "docker";
    };
    volumes = [
      "/mnt/share/autopirate/Movies:/movies:rw"
      "/mnt/share/autopirate/Music:/music:rw"
      "/mnt/share/autopirate/Tv:/tv:rw"
      "media_plex_data:/config:rw"
    ];
    ports = [
      "32400:32400/tcp"
      "3005:3005/tcp"
      "8324:8324/tcp"
      "32469:32469/tcp"
      "1900:1900/udp"
      "32410:32410/udp"
      "32412:32412/udp"
      "32413:32413/udp"
      "32414:32414/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=/dev/dri:/dev/dri:rwm"
      "--hostname=plex"
      "--network-alias=plex"
      "--network=services"
    ];
  };
  systemd.services."docker-plex" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_plex_data.service"
    ];
    requires = [
      "docker-volume-media_plex_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "ghcr.io/linuxserver/prowlarr:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "media_prowlarr_data:/config:rw"
    ];
    ports = [
      "9696:9696/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=prowlarr"
      "--network-alias=prowlarr"
      "--network=services"
    ];
  };
  systemd.services."docker-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_prowlarr_data.service"
    ];
    requires = [
      "docker-volume-media_prowlarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."radarr" = {
    image = "ghcr.io/linuxserver/radarr:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/mnt/share/autopirate/Etc/downloads:/downloads:rw"
      "/mnt/share/autopirate/Etc/torrents:/data:rw"
      "/mnt/share/autopirate/Movies:/movies:rw"
      "media_radarr_data:/config:rw"
    ];
    ports = [
      "7878:7878/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=radarr"
      "--network-alias=radarr"
      "--network=services"
    ];
  };
  systemd.services."docker-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_radarr_data.service"
    ];
    requires = [
      "docker-volume-media_radarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."readarr" = {
    image = "ghcr.io/hotio/readarr:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/mnt/share/autopirate/Books:/books:rw"
      "/mnt/share/autopirate/Etc/downloads:/downloads:rw"
      "/mnt/share/autopirate/Etc/torrents:/data:rw"
      "media_readarr_data:/config:rw"
    ];
    ports = [
      "8787:8787/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=readarr"
      "--network-alias=readarr"
      "--network=services"
    ];
  };
  systemd.services."docker-readarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_readarr_data.service"
    ];
    requires = [
      "docker-volume-media_readarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."searcharr" = {
    image = "toddrob/searcharr";
    environment = {
      "TZ" = "America/New_York";
    };
    volumes = [
      "media_searcharr_data:/app:rw"
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
  virtualisation.oci-containers.containers."sonarr" = {
    image = "ghcr.io/linuxserver/sonarr:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/mnt/share/autopirate/Etc/downloads:/downloads:rw"
      "/mnt/share/autopirate/Etc/torrents:/data:rw"
      "/mnt/share/autopirate/Tv:/tv:rw"
      "media_sonarr_data:/config:rw"
    ];
    ports = [
      "8989:8989/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=sonarr"
      "--network-alias=sonarr"
      "--network=services"
    ];
  };
  systemd.services."docker-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_sonarr_data.service"
    ];
    requires = [
      "docker-volume-media_sonarr_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."tautulli" = {
    image = "ghcr.io/linuxserver/tautulli:latest";
    environment = {
      "PGID" = "1";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "media_tautulli_data:/config:rw"
    ];
    ports = [
      "8181:8181/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=tautulli"
      "--network-alias=tautulli"
      "--network=services"
    ];
  };
  systemd.services."docker-tautulli" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-media_tautulli_data.service"
    ];
    requires = [
      "docker-volume-media_tautulli_data.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };
  virtualisation.oci-containers.containers."watchtower" = {
    image = "containrrr/watchtower";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=watchtower"
      "--network=media_default"
    ];
  };
  systemd.services."docker-watchtower" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-media_default.service"
    ];
    requires = [
      "docker-network-media_default.service"
    ];
    partOf = [
      "docker-compose-media-root.target"
    ];
    wantedBy = [
      "docker-compose-media-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-media_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f media_default";
    };
    script = ''
      docker network inspect media_default || docker network create media_default
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-media_bazarr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_bazarr_data || docker volume create media_bazarr_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_calibre_server_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_calibre_server_data || docker volume create media_calibre_server_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_calibre_web_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_calibre_web_data || docker volume create media_calibre_web_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_plex_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_plex_data || docker volume create media_plex_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_prowlarr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_prowlarr_data || docker volume create media_prowlarr_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_radarr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_radarr_data || docker volume create media_radarr_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_readarr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_readarr_data || docker volume create media_readarr_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_searcharr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_searcharr_data || docker volume create media_searcharr_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_sonarr_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_sonarr_data || docker volume create media_sonarr_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };
  systemd.services."docker-volume-media_tautulli_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect media_tautulli_data || docker volume create media_tautulli_data
    '';
    partOf = [ "docker-compose-media-root.target" ];
    wantedBy = [ "docker-compose-media-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-media-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
