{
  isDarwin,
  ...
}:

let
  colors = import ./colors.nix;
  fontFamily = "JetBrains Mono";
in
{
  xdg.configFile."alacritty/alacritty.toml".text =
    ''
      [colors]
      [colors.primary]
      background = "${colors.primary.background}"
      foreground = "${colors.primary.foreground}"

      [colors.normal]
      black = "${colors.normal.black}"
      blue = "${colors.normal.blue}"
      cyan = "${colors.normal.cyan}"
      green = "${colors.normal.green}"
      magenta = "${colors.normal.magenta}"
      red = "${colors.normal.red}"
      white = "${colors.normal.white}"
      yellow = "${colors.normal.yellow}"

      [colors.bright]
      black = "${colors.bright.black}"
      blue = "${colors.bright.blue}"
      cyan = "${colors.bright.cyan}"
      green = "${colors.bright.green}"
      magenta = "${colors.bright.magenta}"
      red = "${colors.bright.red}"
      white = "${colors.bright.white}"
      yellow = "${colors.bright.yellow}"

      [env]
      TERM = "alacritty"

      [font]
      size = 12
      [font.bold]
      family = "${fontFamily}"
      style = "Bold"

      [font.bold_italic]
      family = "${fontFamily}"
      style = "Bold Italic"

      [font.italic]
      family = "${fontFamily}"
      style = "Italic"

      [font.normal]
      family = "${fontFamily}"
      style = "Regular"
    ''
    + (
      if isDarwin then
        ''

          [window]
          decorations = "transparent"
          dynamic_padding = true
          dynamic_title = true
          option_as_alt = "Both"

          [window.padding]
          x = 5
          y = 25
        ''
      else
        ""
    );
}
