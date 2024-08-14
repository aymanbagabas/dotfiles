{ pkgs, pkgs-unstable, modulesPath, hostname, user, ... }:

let
  serverHostPath = "/etc/nixos/server-host";
  serverHost = if builtins.pathExists serverHostPath
    then builtins.readFile serverHostPath
    else "example.com";

  email = "";
in {
  imports = [
    ../nixos.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  proxmoxLXC = {
    privileged = false;
    manageHostName = false;
  };

  # Make initial login passwordless.
  # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.initialHashedPassword
  users.users.root.initialHashedPassword = "";
  users.users.${user}.initialHashedPassword = "";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.hostName = hostname;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = email;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${serverHost} = {
      addSSL = true;
      enableACME = true;
    };
  };
}
