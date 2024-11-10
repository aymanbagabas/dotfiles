{
  pkgs,
  user,
  isDarwin,
  ...
}:

{
  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.${user} = {
    name = "${user}";
    home = (if isDarwin then "/Users" else "/home") + "/${user}";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINoKgI3rm5LJSKyaKg8ke4prIwRao0rMdrennfVwfLQx"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtyoux0Kzj64dAbq/WWbPKmxWBLb1Wug3hBMyH/71z3"
    ];
  };

  nix = {
    package = pkgs.nix;
    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise = {
      automatic = true;
    };
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://aymanbagabas.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "aymanbagabas.cachix.org-1:4juS6J97CtV+S4TKmcNXp2hxVbaWFvsDrn/vl/fM2Gg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "${user}"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = import ../modules/nixpkgs-config.nix;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];
  environment.systemPackages = with pkgs; [
    cachix
    coreutils
    curl
    git
    neovim
    unzip
    wget
  ];
}
