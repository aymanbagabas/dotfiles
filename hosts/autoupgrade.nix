{ ... }:
{
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "03:00";
    flake = "github:aymanbagabas/dotfiles";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
  };
}
