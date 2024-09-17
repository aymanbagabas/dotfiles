{ pkgs, ... }:

{
  programs.go = {
    enable = true;
    package = pkgs.go_1_23;
    goPath = ".go";
    goPrivate = [ "github.com/aymanbagabas" "github.com/charmbracelet" ];
  };
}
