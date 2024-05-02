{ ... }:

{
  xdg.configFile."kitty/kitty.conf".text = ''
  macos_option_as_alt left

  font_family Inconsolata LGC
  bold_font Inconsolata LGC Bold
  italic_font Inconsolata LGC Italic
  bold_italic_font Inconsolata LGC Bold Italic

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

  tab_separator " │ "
  tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}"
  tab_bar_edge top
  tab_bar_style separator

  # One Dark by Giuseppe Cesarano, https://github.com/GiuseppeCesarano
  # This work is licensed under the terms of the GPL-2.0 license.
  # For a copy, see https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
  
  # Colors
  
  foreground #979eab
  background #282c34
  
  color0 #282c34
  color1 #e06c75
  color2 #98c379
  color3 #e5c07b
  color4 #61afef
  color5 #be5046
  color6 #56b6c2
  color7 #979eab
  color8 #393e48
  color9 #d19a66
  color10 #56b6c2
  color11 #e5c07b
  color12 #61afef
  color13 #be5046
  color14 #56b6c2
  color15 #abb2bf
  
  # Tab Bar
  
  active_tab_foreground   #282c34
  active_tab_background   #979eab
  inactive_tab_foreground #abb2bf
  inactive_tab_background #282c34
  '';
}
