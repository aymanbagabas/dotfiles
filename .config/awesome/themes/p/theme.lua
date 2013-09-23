---------------------------
------    mony960    ------
---------------------------

home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"
_theme = themes .. "/p"
icons = confdir .. "/icons"
_icons = _theme .. "/icons"

theme = {}

theme.font          = "Monaco 8"
theme.dfont         = "Monaco-8"

theme.bg_normal     = "#00000088"
theme.bg_focus      = "#00000000"
theme.bg_urgent     = theme.bg_focus
theme.bg_systray    = '#00000000'

theme.fg_normal     = "#919AA1"--#D8D6B8"--#BABAA0"--#E7E4C4"
theme.fg_focus      = "#76728B"
theme.fg_urgent     = "#ff0000"
theme.fg_minimize   = "#919AA1"--#A4BBC3"

theme.border_width  = 6
theme.border_normal = "#000000"
theme.border_focus  = "#605678"
theme.border_marked = "#91231c"

theme.useless_gap_width = 25

-- There are other variable sets
-- overriding the p one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.taglist_font = theme.font
theme.taglist_bg_normal = "png:" .. _icons .. "/tag_bg.png"
theme.taglist_bg_focus = theme.taglist_bg_normal
theme.taglist_bg_urgent = theme.taglist_bg_normal
theme.taglist_fg_focus = "#605678"
theme.taglist_fg_normal = "#E7E4C4"--#919AA1"

theme.tooltip_bg_color = "#919AA1"
theme.tooltip_fg_color = "#E7E4C4"
theme.tooltip_border_width = 1
theme.tooltip_border_color = "#605678"

theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg_focus = theme.titlebar_bg_normal
theme.titlebar_fg_normal = theme.titlebar_bg_normal
theme.titlebar_fg_focus = "#605678"
theme.titlebar_size = 20

-- Tasklist properties
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_focus = "#76728B"--#3F3246"
theme.tasklist_bg_normal = "#00000000"
theme.tasklist_bg_focus = theme.tasklist_bg_normal
theme.tasklist_bg_urgent = theme.tasklist_bg_normal
theme.tasklist_bg_minimize = theme.tasklist_bg_normal
theme.bg_image_normal = _icons .. "/transparent.png"
theme.bg_image_focus = theme.bg_image_normal
theme.bg_image_urgent = theme.bg_image_normal
theme.bg_image_minimize = theme.bg_image_normal
theme.tasklist_sticky = "<span color='#E7E4C4'> (S)</span>"
theme.tasklist_ontop = "<span color='#E7E4C4'> (T)</span>"
theme.tasklist_floating = "<span color='#E7E4C4'> (F)</span>"
theme.tasklist_maximized_horizontal = "<span color='#E7E4C4'> (M)</span>"
theme.tasklist_maximized_vertical = ""
theme.tasklist_plain_task_name = false

-- Display the taglist squares
theme.taglist_squares_sel   = nil
theme.taglist_squares_unsel = nil

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal = theme.bg_normal
theme.menu_bg_focus = theme.bg_normal
theme.menu_fg_normal = theme.fg_normal
theme.menu_fg_focus = theme.fg_focus
theme.menu_submenu_icon = _theme .. "/submenu.png"
theme.menu_height = 15
theme.menu_width  = 150
theme.menu_border_width = 0
theme.menu_icon = _icons .. "/menu.png"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = _theme .. "/titlebar/close.png"
theme.titlebar_close_button_focus = theme.titlebar_close_button_normal

theme.titlebar_ontop_button_active  = _theme .. "/titlebar/ontop.png"
theme.titlebar_ontop_button_inactive = theme.titlebar_ontop_button_active

theme.titlebar_sticky_button_inactive = _theme .. "/titlebar/sticky.png"
theme.titlebar_sticky_button_active  = theme.titlebar_sticky_button_normal_inactive

theme.titlebar_floating_button_inactive = _theme .. "/titlebar/floating.png"
theme.titlebar_floating_button_active  = theme.titlebar_floating_button_inactive

theme.titlebar_maximized_button_inactive = _theme .. "/titlebar/maximized.png"
theme.titlebar_maximized_button_active  = theme.titlebar_maximized_button_inactive

theme.titlebar_minimize_button_inactive  = _theme .. "/titlebar/minimize.png"
theme.titlebar_minimize_button_active = _theme .. theme.titlebar_minimize_button_inactive

theme.wallpaper = _theme .. '/background.jpg'

-- You can use your own layout icons like this:
theme.layout_fairh = _theme .. "/layouts/fairh.png"
theme.layout_fairv = _theme .. "/layouts/fairv.png"
theme.layout_floating  = _theme .. "/layouts/floating.png"
theme.layout_magnifier = _theme .. "/layouts/magnifier.png"
theme.layout_max = _theme .. "/layouts/max.png"
theme.layout_fullscreen = _theme .. "/layouts/fullscreen.png"
theme.layout_tilebottom = _theme .. "/layouts/tilebottom.png"
theme.layout_tileleft   = _theme .. "/layouts/tileleft.png"
theme.layout_tile = _theme .. "/layouts/tile.png"
theme.layout_tiletop = _theme .. "/layouts/tiletop.png"
theme.layout_spiral  = _theme .. "/layouts/spiral.png"
theme.layout_dwindle = _theme .. "/layouts/dwindle.png"

theme.awesome_icon = icons .. "/awesome16.png"

-- Icons
theme.bg_left = _icons .. "/bg_left.png"
theme.bg_right = _icons .. "/bg_right.png"
theme.separator = _icons .. "/spr.png"
theme.focus_dot = _icons .. "/f_dot.png"
theme.normal_dot = _icons .. "/n_dot.png"
theme.mpd_prev = _icons .. "/prev.png"
theme.mpd_next = _icons .. "/next.png"
theme.mpd_play = _icons .. "/play.png"
theme.mpd_pause = _icons .. "/pause.png"
theme.mpd_stop = _icons .. "/stop.png"
theme.mpd_cover = _icons .. "/cover.png"
theme.titlebar_left = _icons .. "/tb_bg_left.png"
theme.titlebar_right = _icons .. "/tb_bg_right.png"
theme.tag_end = _icons .. "/tag_bg_end.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Faenza-Soiree"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
