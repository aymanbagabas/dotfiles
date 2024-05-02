{ pkgs, ... }:

{
  enable = true;
  package = pkgs.go_1_22;
  goPath = ".go";
  goPrivate = [
    "github.com/aymanbagabas"
    "github.com/charmbracelet"
  ];
}
