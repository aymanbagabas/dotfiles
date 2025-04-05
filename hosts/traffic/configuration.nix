{
  config,
  user,
  pkgs,
  dotfiles,
  ...
}:

with pkgs.lib;

let
  email = builtins.readFile "${dotfiles}/vars/email";
  mainDomain = builtins.readFile "${dotfiles}/vars/main_domain";
  subMainDomain = builtins.readFile "${dotfiles}/vars/sub_main_domain";
  altDomain = builtins.readFile "${dotfiles}/vars/alt_domain";
  dnsProvider = builtins.readFile "${dotfiles}/vars/dns_provider";

  useStaging = false;
in
{
  imports = [
    ../autoupgrade.nix
    ../nixos.nix
    ./secrets.nix
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable serial console display on serial=0.
  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "${email}";
      server = mkIf useStaging "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
    certs."${subMainDomain}" = {
      group = "wheel";
      domain = "*.${subMainDomain}";
      dnsProvider = dnsProvider;
      dnsPropagationCheck = true;
      extraDomainNames = [
        "${altDomain}"
        "*.${altDomain}"
        "${subMainDomain}"
        "*.${subMainDomain}"
      ];
      environmentFile = "${config.sops.secrets.cert.path}";
    };
  };

  services.nginx = {
    enable = true;
    user = "${user}";
    group = "wheel";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedBrotliSettings = true;
    virtualHosts =
      let
        base = locations: {
          inherit locations;
          forceSSL = true;
          enableACME = true;
        };
        proxy =
          url:
          base {
            "/" = {
              proxyPass = "${url}";
              # Host and X-Forwarded-For headers are added using the
              # "recommendedProxySettings". Some applications don't recognize
              # X-Forwarded-Proto so we need to add X-Forwarded-Protocol as well.
              extraConfig = ''
                            proxy_set_header X-Forwarded-Protocol $scheme;
                	  '';
            };
          };
      in
      {
        "radarr.${altDomain}" = proxy "http://media.local:7878/";
        "sonarr.${altDomain}" = proxy "http://media.local:8989/";
        "prowlarr.${altDomain}" = proxy "http://media.local:9696/";
        "readarr.${altDomain}" = proxy "http://media.local:8787/";
        "books.${altDomain}" = proxy "http://media.local:8083/";
        "convert.${altDomain}" = proxy "http://media.local:3000/";
        "nas.${altDomain}" = base {
          "/" = {
            proxyPass = "https://nas.local:5001/";
            # Skip the SSL verification for the NAS as it uses a self-signed certificate.
            extraConfig = ''
              proxy_set_header X-Forwarded-Protocol $scheme;
              proxy_ssl_verify off;
              client_max_body_size 4G;
            '';
          };
        };
        "plex.${altDomain}" = base {
          "/" = {
            proxyPass = "http://media.local:32400/";
            extraConfig = ''
              proxy_set_header X-Forwarded-Protocol $scheme;

              proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
              proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
              proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";

              proxy_redirect off;
              proxy_buffering off;
            '';
          };
        };
        "jellyfin.${altDomain}" = base {
          "/" = {
            proxyPass = "http://media.local:8096/";
            extraConfig = ''
              proxy_set_header X-Forwarded-Protocol $scheme;

              # Disable buffering when the nginx proxy gets very resource heavy upon streaming
              proxy_buffering off;
            '';
          };
          "/socket" = {
            proxyPass = "http://media.local:8096/";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
        "${altDomain}" = base { "/".return = "301 http://${mainDomain}$request_uri"; };
      };
  };

  # This is needed for nginx to be able to read other processes
  # directories in `/run`. Else it will fail with (13: Permission denied)
  systemd.services.nginx.serviceConfig.ProtectHome = false;
}
