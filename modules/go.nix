{ pkgs, ... }:

{
  programs.go = {
    enable = true;
    package = pkgs.go_1_23;
    goPath = ".go";
  };
}
