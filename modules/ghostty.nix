{ pkgs, isHeadless, ... }:

let
  lib = pkgs.lib;
  colors = import ./colors.nix;
in {
  xdg.configFile = lib.mkIf (!isHeadless) {
    "ghostty/config".text = ''
      term = "xterm-ghostty"
      #term = "ghostty"

      font-family = "Inconsolata LGC"
      # font-style = "Regular"
      # font-family-bold = "Inconsolata LGC"
      # font-style-bold = "Bold"
      # font-family-italic = "Inconsolata LGC"
      # font-style-italic = "Italic"
      # font-family-bold-italic = "Inconsolata LGC"
      # font-style-bold-italic = "BoldItalic"

      font-size = 12
      font-thicken = true

      adjust-cell-width = -10%
      # adjust-underline-position = 50
      #adjust-underline-thickness = -1

      background = ${colors.primary.background}
      foreground = ${colors.primary.foreground}

      # black
      palette = 0=${colors.normal.black}
      # red
      palette = 1=${colors.normal.red}
      # green
      palette = 2=${colors.normal.green}
      # yellow
      palette = 3=${colors.normal.yellow}
      # blue
      palette = 4=${colors.normal.blue}
      # magenta
      palette = 5=${colors.normal.magenta}
      # cyan
      palette = 6=${colors.normal.cyan}
      # white
      palette = 7=${colors.normal.white}

      # bright black
      palette = 8=${colors.bright.black}
      # bright red
      palette = 9=${colors.bright.red}
      # bright green
      palette = 10=${colors.bright.green}
      # bright yellow
      palette = 11=${colors.bright.yellow}
      # bright blue
      palette = 12=${colors.bright.blue}
      # bright magenta
      palette = 13=${colors.bright.magenta}
      # bright cyan
      palette = 14=${colors.bright.cyan}
      # bright white
      palette = 15=${colors.bright.white}

      macos-option-as-alt = true
      macos-titlebar-style = "tabs"

      # vim:ft=config
    '';
  };
}
