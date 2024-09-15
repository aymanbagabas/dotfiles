{ config, user, pkgs, dotfiles, ... }:

with pkgs.lib;

let
  email = builtins.readFile "${dotfiles}/vars/email";
  mainDomain = builtins.readFile "${dotfiles}/vars/main_domain";
  subMainDomain = builtins.readFile "${dotfiles}/vars/sub_main_domain";
  altDomain = builtins.readFile "${dotfiles}/vars/alt_domain";
  dnsProvider = builtins.readFile "${dotfiles}/vars/dns_provider";

  useStaging = false;
in {
  imports = [
    ../genericlxc/configuration.nix
    ./secrets.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "${email}";
      server = mkIf useStaging "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
    certs."${mainDomain}" = {
      group = "wheel";
      domain = "${subMainDomain}";
      dnsProvider = dnsProvider;
      dnsPropagationCheck = true;
      extraDomainNames = [
        "*.${subMainDomain}"
        "${altDomain}"
        "*.${altDomain}"
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
    resolver.addresses = [
      "192.168.2.2"
      "127.0.0.1"
    ];
    virtualHosts = let
      base = locations: {
        inherit locations;
	forceSSL = true;
	enableACME = true;
      };
      proxy = url: base {
        "/" = {
          proxyPass = "${url}";
          extraConfig = ''
            proxy_set_header X-Forwarded-Protocol $scheme;
	  '';
	};
      };
    in {
      "radarr.${altDomain}" = proxy "http://media.local:7878/";
      "sonarr.${altDomain}" = proxy "http://media.local:8989/";
      "prowlarr.${altDomain}" = proxy "http://media.local:9696/";
      "readarr.${altDomain}" = proxy "http://media.local:8787/";
      "books.${altDomain}" = proxy "http://media.local:8083/";
      "nas.${altDomain}" = proxy "https://nas.local/" // {
        locations = {
          # Skip the SSL verification for the NAS as it uses a self-signed certificate.
          "/".extraConfig = ''
            proxy_ssl_verify off;
          '';
        };
      };
      "plex.${altDomain}" = let
        extraConfig = ''
          proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
          proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
          proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";

          proxy_redirect off;
          proxy_buffering off;
	'';
      in base {
        "/" = {
	  proxyPass = "http://media.local:32400/";
	  inherit extraConfig;
	};
      };
      "jellyfin.${altDomain}" = base {
        "/" = {
	  proxyPass = "http://media.local:8096/";
	  extraConfig = ''
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
      "${altDomain}" = base {
        "/".return = "301 http://${mainDomain}$request_uri";
      };
    };
  };

  # This is needed for nginx to be able to read other processes
  # directories in `/run`. Else it will fail with (13: Permission denied)
  systemd.services.nginx.serviceConfig.ProtectHome = false;
}
