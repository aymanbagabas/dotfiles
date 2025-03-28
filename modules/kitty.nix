{ ... }:

let
  colors = import ./colors.nix;
in
{
  xdg.configFile."kitty/kitty.conf".text = ''
    macos_option_as_alt left

    font_family JetBrains Mono
    bold_font JetBrains Mono Bold
    italic_font JetBrains Mono Italic
    bold_italic_font JetBrains Mono Bold Italic

    font_size 12.0

    map cmd+1 goto_tab 1
    map cmd+2 goto_tab 2
    map cmd+3 goto_tab 3
    map cmd+4 goto_tab 4
    map cmd+5 goto_tab 5
    map cmd+6 goto_tab 6
    map cmd+7 goto_tab 7
    map cmd+8 goto_tab 8
    map cmd+9 goto_tab 9
    map cmd+0 goto_tab 0

    tab_bar_edge top
    tab_bar_style separator
    tab_separator " │ "
    tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title} #{index}"

    # One Dark by Giuseppe Cesarano, https://github.com/GiuseppeCesarano
    # This work is licensed under the terms of the GPL-2.0 license.
    # For a copy, see https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.

    # Colors

    foreground ${colors.primary.foreground}
    background ${colors.primary.background}

    color0 ${colors.normal.black}
    color1 ${colors.normal.red}
    color2 ${colors.normal.green}
    color3 ${colors.normal.yellow}
    color4 ${colors.normal.blue}
    color5 ${colors.normal.magenta}
    color6 ${colors.normal.cyan}
    color7 ${colors.normal.white}
    color8 ${colors.bright.black}
    color9 ${colors.bright.red}
    color10 ${colors.bright.green}
    color11 ${colors.bright.yellow}
    color12 ${colors.bright.blue}
    color13 ${colors.bright.magenta}
    color14 ${colors.bright.cyan}
    color15 ${colors.bright.white}

    # Tab Bar

    selection_background ${colors.primary.foreground}
    selection_foreground ${colors.primary.background}

    url_color #565c64
    cursor ${colors.normal.white}
    active_border_color #545862
    inactive_border_color #353b45

    active_tab_foreground ${colors.primary.foreground}
    active_tab_background ${colors.primary.background}
    inactive_tab_background #353b45
    inactive_tab_foreground #565c64
    tab_bar_background #353b45
  '';
}
