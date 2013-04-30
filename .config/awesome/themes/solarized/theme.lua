---------------------------
-- arch awesome theme -- 
---------------------------

home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"
micons = confdir .. "/icons"

theme = {}

-- {{{ Colors
theme.colors = {}
theme.colors.base3 = "#002b36"
theme.colors.base2 = "#073642"
theme.colors.base1 = "#586e75"
theme.colors.base0 = "#657b83"
theme.colors.base00 = "#839496"
theme.colors.base01 = "#93a1a1"
theme.colors.base02 = "#eee8d5"
theme.colors.base03 = "#fdf6e3"
theme.colors.yellow = "#b58900"
theme.colors.orange = "#cb4b16"
theme.colors.red = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet = "#6c71c4"
theme.colors.blue = "#268bd2"
theme.colors.cyan = "#2aa198"
theme.colors.green = "#859900"
-- }}}

theme.font          = "Termsyn 8"
theme.dfont          = "Termsyn-8"

theme.bg_normal = theme.colors.base3
theme.bg_focus = theme.colors.base1
theme.bg_urgent = theme.colors.red
theme.bg_minimize   = theme.colors.base3
theme.bg_systray = theme.bg_normal

theme.fg_normal = theme.colors.base01
theme.fg_focus = theme.colors.base03
theme.fg_urgent = theme.colors.base3
theme.fg_minimize   = theme.colors.base1

theme.border_width  = 1
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent

-- There are other variable sets
-- overriding the arch one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#262729"
theme.taglist_bg_color = theme.colors.base3
theme.taglist_fg_color = theme.colors.base01
theme.taglist_bg_focus = theme.colors.base3
theme.taglist_fg_focus = theme.colors.base03
theme.tasklist_fg_focus = theme.colors.base03
theme.tasklist_bg_focus = theme.bg_normal
theme.titlebar_fg_normal = theme.colors.base03
theme.titlebar_bg_normal = theme.colors.base1
theme.tooltip_bg_color = theme.colors.base1
theme.tooltip_fg_color = theme.colors.base03
theme.tooltip_border_width = theme.menu_border_width

-- Display the taglist squares
theme.taglist_squares_sel   = "/home/mony/.config/awesome/themes/arch/taglist/squaref_b.png"
theme.taglist_squares_unsel = "/home/mony/.config/awesome/themes/arch/taglist/square_b.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_fg_normal = theme.colors.base03
theme.menu_bg_normal = theme.colors.base3
theme.menu_submenu_icon = "/home/mony/.config/awesome/themes/arch/submenu.png"
theme.menu_height = 15
theme.menu_width  = 120
theme.menu_border_color = theme.fg_focus
theme.menu_border_width = 0
theme.menu_icon = micons .. "/menu.png"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/home/mony/.config/awesome/themes/arch/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/home/mony/.config/awesome/themes/arch/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/mony/.config/awesome/themes/arch/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/mony/.config/awesome/themes/arch/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/mony/.config/awesome/themes/arch/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/home/mony/.config/awesome/themes/arch/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/mony/.config/awesome/themes/arch/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/mony/.config/awesome/themes/arch/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/mony/.config/awesome/themes/arch/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/home/mony/.config/awesome/themes/arch/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/home/mony/.config/awesome/themes/arch/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/home/mony/.config/awesome/themes/arch/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/home/mony/.config/awesome/themes/arch/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/home/mony/.config/awesome/themes/arch/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/mony/.config/awesome/themes/arch/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/mony/.config/awesome/themes/arch/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/mony/.config/awesome/themes/arch/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/home/mony/.config/awesome/themes/arch/titlebar/maximized_focus_active.png"

--theme.wallpaper = "/home/mony/Images/figure8.png" using nitrogen

-- You can use your own layout icons like this:
theme.layout_fairh = "/home/mony/.config/awesome/themes/solarized/layouts-small/fairh.png"
theme.layout_fairv = "/home/mony/.config/awesome/themes/solarized/layouts-small/fairv.png"
theme.layout_floating  = "/home/mony/.config/awesome/themes/solarized/layouts-small/floating.png"
theme.layout_magnifier = "/home/mony/.config/awesome/themes/solarized/layouts-small/magnifier.png"
theme.layout_max = "/home/mony/.config/awesome/themes/solarized/layouts-small/max.png"
theme.layout_fullscreen = "/home/mony/.config/awesome/themes/solarized/layouts-small/fullscreen.png"
theme.layout_tilebottom = "/home/mony/.config/awesome/themes/solarized/layouts-small/tilebottom.png"
theme.layout_tileleft   = "/home/mony/.config/awesome/themes/solarized/layouts-small/tileleft.png"
theme.layout_tile = "/home/mony/.config/awesome/themes/solarized/layouts-small/tile.png"
theme.layout_tiletop = "/home/mony/.config/awesome/themes/solarized/layouts-small/tiletop.png"
theme.layout_spiral  = "/home/mony/.config/awesome/themes/solarized/layouts-small/spiral.png"
theme.layout_dwindle = "/home/mony/.config/awesome/themes/solarized/layouts-small/dwindle.png"

theme.awesome_icon = "/home/mony/.config/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Faenza"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
