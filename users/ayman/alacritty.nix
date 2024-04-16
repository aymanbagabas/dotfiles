{ pkgs, isDarwin, isHeadless, ... }:

let
  lib = pkgs.lib;
  colors = import ./colors.nix;
  fontFamily = "Inconsolata LGC Nerd Font";
in {
  programs.alacritty = {
    enable = !isHeadless;
    settings = {
      env = {
        TERM = "alacritty";
        #TERM = "xterm-256color";
      };
      colors = colors;
      font = {
        size = 12;
        normal = {
          family = fontFamily;
          style = "Regular";
        };
        bold = {
          family = fontFamily;
          style = "Bold";
        };
        italic = {
          family = fontFamily;
          style = "Italic";
        };
        bold_italic = {
          family = fontFamily;
          style = "Bold Italic";
        };
      };
      window = lib.mkIf isDarwin {
        decorations = "transparent";
        dynamic_title = true;
        dynamic_padding = true;
        option_as_alt = "Both";
        padding = {
          x = 5;
          y = 25;
        };
      };
    };
  };
}
