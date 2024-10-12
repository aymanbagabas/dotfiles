{ pkgs, user, ... }:

let
  homeDirectory = (if pkgs.stdenv.isDarwin then "/Users" else "/home") + "/${user}";
in
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
      whitelist = {
        prefix = [
          "${homeDirectory}/.dotfiles"
          "${homeDirectory}/Source/aymanbagabas"
          "${homeDirectory}/Source/charmbracelet"
        ];
      };
    };
  };
}
