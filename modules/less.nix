{ pkgs, ... }:

{
  programs.less.enable = true;
  programs.lesspipe.enable = true;

  home.packages = with pkgs; [
    sourceHighlight
  ];
}
