# Media runs on a Proxmox LXC container, so we need to add the Proxmox LXC
# module to the imports list.
{ modulesPath, user, ... }:

{
  imports = [
    ../nixos.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  # Make user login passwordless.
  # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.initialHashedPassword
  users.users.root.initialHashedPassword = "";
  users.users.${user}.initialHashedPassword = "";

  proxmoxLXC = {
    privileged = false;
    manageHostName = false;
  };

  services.nginx = {
    enable = true;
    upstreams = {
      tautulli.servers."media.local:8181" = { };
    };
    virtualHosts."media.local" = {
      locations."~ /tautulli/(.*)" = {
        proxyPass = "http://tautulli/$1$is_args$args";
        priority = 1;
        extraConfig = ''
          proxy_redirect off;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Host $server_name;
        '';
      };
    };
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
