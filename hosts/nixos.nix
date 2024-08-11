{ user, hostname, ... }:

{
  imports = [
    ./shared.nix
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Add "@wheel" group to trusted-users.
  nix.settings.trusted-users = [ "@wheel" ];

  # Run garbage collection weekly.
  nix.gc.dates = "weekly";

  networking.hostName = hostname;

  # Enable passwordless sudo
  security.sudo.extraRules = [
    {
      users = [ "${user}" ];
      commands = [
      {
        command = "ALL";
        options = [ "NOPASSWD" ];
      }
      ];
    }
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
  };

  # Common services.
  services.openssh.enable = true;
  services.cron.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };
}
