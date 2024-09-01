{ pkgs, ... }:

{
  programs.less.enable = true;
  programs.lesspipe.enable = true;

  home.packages = with pkgs; [
    sourceHighlight
  ];

  home.sessionVariables = {
    PAGER = "less";
    LESS = "-R --mouse --wheel-lines=3";

    # LESSOPEN="| $(command -v src-hilite-lesspipe.sh) %s"; # replaced by lesspipe
  };
}
