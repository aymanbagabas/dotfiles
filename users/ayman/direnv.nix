{ pkgs, ... }:

let
  homeDirectory = (if pkgs.stdenv.isDarwin then "/Users" else "/home") + "/ayman";
in
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = { load_dotenv = true; };
      whitelist = {
        prefix = [
          "${homeDirectory}/Source/aymanbagabas"
          "${homeDirectory}/Source/charmbracelet"
        ];
      };
    };
  };
}
