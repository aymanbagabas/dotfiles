{
  isDarwin,
  ...
}:

let
  colors = import ./colors.nix;
  fontFamily = "JetBrains Mono";
in
{
  xdg.configFile."rio/config.toml".text =
    ''
      [colors]
      background = "${colors.primary.background}"
      foreground = "${colors.primary.foreground}"
      cursor = "${colors.primary.foreground}"
      vi-cursor = "${colors.primary.foreground}"

      selection-foreground = "${colors.primary.background}"
      selection-background = "${colors.primary.foreground}"

      light-black = "${colors.normal.black}"
      light-blue = "${colors.normal.blue}"
      light-cyan = "${colors.normal.cyan}"
      light-green = "${colors.normal.green}"
      light-magenta = "${colors.normal.magenta}"
      light-red = "${colors.normal.red}"
      light-white = "${colors.normal.white}"
      light-yellow = "${colors.normal.yellow}"

      black = "${colors.bright.black}"
      blue = "${colors.bright.blue}"
      cyan = "${colors.bright.cyan}"
      green = "${colors.bright.green}"
      magenta = "${colors.bright.magenta}"
      red = "${colors.bright.red}"
      white = "${colors.bright.white}"
      yellow = "${colors.bright.yellow}"

      env-vars = ["TERM=xterm-rio"]

      [fonts]
      size = 12

      [fonts.regular]
      family = "${fontFamily}"
      style = "Normal"

      [fonts.bold]
      family = "${fontFamily}"
      style = "Normal"
      weight = 800

      [fonts.bold_italic]
      family = "${fontFamily}"
      style = "Italic"
      weight = 800

      [fonts.italic]
      family = "${fontFamily}"
      style = "Italic"

      padding-x = 30
      padding-y = [3, 3]
    ''
    + (
      if isDarwin then
        ''

          [window]
          decorations = "Transparent"
          macos-use-shadow = true

          option_as_alt = "left"
        ''
      else
        ""
    );
}
