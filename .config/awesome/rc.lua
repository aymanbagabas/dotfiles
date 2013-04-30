-- Standard awesome library 
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local capi = {
     screen = screen,
     tag = tag,
     timer = timer,
     mouse = mouse,
     client = client,
     keygrabber = keygrabber
     }
--local eminent = require("eminent")
local vicious = require("vicious")
local bashets = require("bashets")
local scratch = require("scratch")
--shifty = require("shifty")
local blingbling = require("blingbling")
local myplacesmenu = require("myplacesmenu")
local revelation = require("revelation")
local cal = require("cal")
local applicationsmenu = require("applicationsmenu")

-- {{{ Error handling
-- Check if awesome encounteblue an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"
icons = themes .. "/solarized/icons"
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/mony/.config/awesome/themes/solarized/theme.lua")

-- {{{ Autorun

awful.util.spawn("/home/mony/bin/file_tree_menu.py")

function run_once(prg)
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

run_once("parcellite -n")
run_once("compton --config ~/.compton.conf -b")
run_once("nitrogen --restore")
run_once("wmname LG3D")
-- }}}

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc -name Terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
dmenu = "dmenu_path_c | dmenu -i -p 'Run command:' -fn '" .. beautiful.dfont .. "' -h '18' -nb '" .. beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "' -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'"
fileman = "caja --no-desktop"
filemancli = terminal .. " -e ranger"
browser = "firefox"
browsercli = terminal .. " -e w3m"
mail = "thunderbird"
mailcli = terminal .. " -e mutt"
calc = "mate-calc"
htop = terminal .. " -name htop -e htop"
lock = "slimlock"

volmixer = terminal .. " -name alsamixer -e alsamixer"
mpdplr = terminal .. " -name ncmpcpp -e ncmpcpp"
mpdgui = "sonata"
lower_volume = "amixer -q set Master 2%-"
raise_volume = "amixer -q set Master 2%+"
toggle_volume = "amixer set Master toggle"
prev_music = "mpc prev"
next_music = "mpc next"
toggle_play = "mpc toggle"

eth = "enp2s0"
wlan = "wlp3s0"

-- Naughty
naughty.config.defaults.timeout = 7
naughty.config.defaults.margin = "5"
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = capi.mouse.screen
naughty.config.defaults.position = "top_right"
naughty.config.defaults.border_width = beautiful.menu_border_width
naughty.config.defaults.bg = beautiful.bg_focus or '#535d6c'
naughty.config.defaults.fg = beautiful.fg_focus or '#ffffff'

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,        --1
    awful.layout.suit.tile,            --2
    awful.layout.suit.tile.left,       --3
    awful.layout.suit.tile.bottom,     --4
    awful.layout.suit.tile.top,        --5
    awful.layout.suit.fair,            --6
    awful.layout.suit.fair.horizontal, --7
    awful.layout.suit.spiral,          --8
    awful.layout.suit.spiral.dwindle,  --9
    awful.layout.suit.max,             --10
    awful.layout.suit.max.fullscreen,  --11
    awful.layout.suit.magnifier        --12
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.

tags = {
    settings = {
    { 
    names = { "Ƃ", "ƈ", "ƃ", "Ƈ", "ƒ", "Ɓ" },
    icons = { icons .. "/white/arch.png", icons .. "/white/dish.png", icons .. "/white/info_03.png", icons .. "/white/bug_01.png", icons .. "/white/mail.png", icons .. "/white/pacman.png" }, 
    sep = { nil, icons .. "/arrow.png", icons .. "/arrow.png", icons .. "/arrow.png", icons .. "/arrow.png", icons .. "/arrow.png" },
    layouts = { layouts[2], layouts[4], layouts[10], layouts[9], layouts[1], layouts[1] } 
    },
    {
    names = { "ƀ", "Ơ" },
    icons = { icons .. "/white/fox.png", icons .. "/white/empty.png" },
    sep = { nil, icons .. "/arrow.png"},
    layouts = { layouts[11], layouts[1] }
    }}}
for s = 1, screen.count() do
    
    -- Each screen has its own tag table.
      tags[s] = awful.tag(tags.settings[s].names, s, tags.settings[s].layouts)
        for i, t in ipairs(tags[s]) do
        --widget.taglist.fg = beautiful.taglist_fg_normal
            --awful.tag.seticon(tags.settings[s].icons[i], t)
            --awful.tag.seticon(tags.settings[s].sep[i], t)
            --awful.tag.setproperty(t, "icon_only", 1)
        end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

require('freedesktop.utils')
  freedesktop.utils.terminal = terminal  -- default: "xterm"
  freedesktop.utils.icon_theme = { 'Faenza', 'gnome' } -- look inside /usr/share/icons/, default: nil (don't use icon theme)
require('freedesktop.menu')

function mvscr()
     local scrs = {}
     for s = 1, capi.screen.count() do
     scr = 'Screen ' .. s
     scrs[s] = { scr, function () awful.client.movetoscreen(c,s) end }
     scrn = awful.util.table.join(scrs, {
        {"Next Screen",
            function() awful.client.movetoscreen(c,c.screen+1) end
        },
        {"Prev Screen",
            function() awful.client.movetoscreen(c,c.screen-1) end
        }})
     end
     return scrn
end

function mvtag()
     local tags_n = {}
     for t = 1, tag.instances() do --FIXME replace "tag.instances()" with the numbers of tags on mouse.screen
     tagm = 'Tag ' .. t
     tags_n[t] = { tagm, function() awful.client.movetotag(tags[client.focus.screen][t]) end }
     tags_np = awful.util.table.join( tags_n, {
        {"Next tag",
            function (c)
                local curidx = awful.tag.getidx()
                if curidx == 9 then
                   awful.client.movetotag(tags[client.focus.screen][1])
                else
                   awful.client.movetotag(tags[client.focus.screen][curidx + 1])
                end
            end
        },
        {"Prev tag",
            function (c)
                local curidx = awful.tag.getidx()
                if curidx == 1 then
                   awful.client.movetotag(tags[client.focus.screen][9])
                else
                   awful.client.movetotag(tags[client.focus.screen][curidx - 1])
                end
            end
        }
        })
        
     end
     return tags_np
end

function ttag()
     local tags_n = {}
     for t = 1, tag.instances() do --FIXME replace "tag.instances()" with the numbers of tags on mouse.screen
     tagm = 'Toggle Tag ' .. t
     tags_n[t] = { tagm, function() awful.client.toggletag(tags[client.focus.screen][t]) end }
     end
     return tags_n
end

function clsmenu(args)
    _menu = self or {}
    local cls = capi.client.get()
    local cls_t = {}
    for k, c in pairs(cls) do
        cls_t[#cls_t + 1] = {
            awful.util.escape(c.name) or "",
            function ()
                if not c:isvisible() then
                    awful.tag.viewmore(c:tags(), c.screen)
                end
                capi.client.focus = c
                c:raise()
            end,
            c.icon }
    end
    return cls_t
end

function showNavMenu(menu, args)
local cls_t = clsmenu(cls)
local tag_n = mvtag()
local tag_t = ttag()
local scr_n = mvscr()

if not menu then
menu = {theme = { width = 200 }}
end
c = capi.client.focus

fclient = {
        {
            "Close", --✖ 
            function() c:kill() end
        },
        {
            (c.minimized and "Restore") or "Minimize", --⇱ ⇲ 
            function() c.minimized = not c.minimized end
        },	
        {
            (c.maximized_horizontal and "Restore") or "[M] Maximize",
            function () c.maximized_horizontal = not c.maximized_horizontal c.maximized_vertical = not c.maximized_vertical end
        },
        {
            (c.sticky and "Un-Stick") or "[S] Stick", --⚫ ⚪ 
            function() c.sticky = not c.sticky end
        },
        {
            (c.ontop and "Offtop") or "[T] Ontop", --⤼ ⤽ 
            function()
                c.ontop = not c.ontop
                if c.ontop then c:raise() end
            end
        },
        {
            ((awful.client.floating.get(c) and "Tile") or "[F] Float"), --▦ ☁ 
            function() awful.client.floating.toggle(c) end
        },
        {"Master",
            function() c:swap(awful.client.getmaster(1)) end
        },
        {"Slave",
            function() awful.client.setslave(c) end
        }
        }
local mynav = {
        {awful.util.escape(c.name),
            fclient, c.icon
        },
        {"Move to Tag",
            tag_n
        },
        {"Toggle Tag",
            tag_t
        },
        {"Move to Screen",
            scr_n
        },
        {"Clients",
            cls_t
        },
}
menu.items = mynav

local m = awful.menu.new(menu)
m:show(args)
return m
end

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

exitmenu = {
   { "Shutdown", "poweroff", "/usr/share/icons/Faenza/actions/48/system-shutdown.png" },
   { "Restart", "reboot", "/usr/share/icons/Faenza/actions/48/view-refresh.png" },
   { "Lock", "slimlock", "/usr/share/icons/Faenza/actions/48/system-lock-screen.png" },
   { "awesome", myawesomemenu, beautiful.awesome_icon }
}

volume = {
   { "Un/Mute", "amixer set Master toggle", "/usr/share/icons/Faenza/status/48/audio-volume-muted.png" },
   { "30%", "amixer set Master 30%", "/usr/share/icons/Faenza/status/48/audio-volume-low.png" },
   { "50%", "amixer set Master 50%", "/usr/share/icons/Faenza/status/48/audio-volume-low.png" },
   { "80%", "amixer set Master 80%", "/usr/share/icons/Faenza/status/48/audio-volume-medium.png" },
   { "100%", "amixer set Master 100%", "/usr/share/icons/Faenza/status/48/audio-volume-high.png" },
   { "Mixer", volmixer }
}

musicmenu = {
   { "Play/Pause", "mpc toggle", "/usr/share/icons/Faenza/actions/48/stock_media-play.png" },
   { "Stop", "mpc stop", "/usr/share/icons/Faenza/actions/48/stock_media-stop.png" },
   { "Previous", "mpc prev", "/usr/share/icons/Faenza/actions/48/stock_media-prev.png" },
   { "Next", "mpc next", "/usr/share/icons/Faenza/actions/48/stock_media-next.png" },
   { "CLI", mpdplr, "/usr/share/icons/Faenza/apps/48/multimedia-volume-control.png" },
   { "GUI", mpdgui, "/usr/share/icons/Faenza/apps/48/multimedia-volume-control.png" },
   { "Volume", volume, "/usr/share/icons/Faenza/status/48/stock_volume.png" }

}

mymenu = awful.util.table.join({
                                    { "File Manager", fileman, "/usr/share/icons/Faenza/apps/48/file-manager.png" },
                                    { "Browser", browser, "/usr/share/icons/Faenza/apps/48/browser.png" },
                                    { "Terminal", terminal, "/usr/share/icons/Faenza/apps/48/Terminal.png" },
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil},
                                    { "Files", myplacesmenu.myplacesmenu(), "/usr/share/icons/Faenza/places/48/folder-home.png"},
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil}
                                    },
                                    freedesktop.menu.new(),
                                    {
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil},
                                    { "Music", musicmenu, "/usr/share/icons/Faenza/apps/48/multimedia-volume-control.png" },
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil},
                                    { "Exit", exitmenu, "/usr/share/icons/Faenza/actions/48/exit.png"}
})

mymainmenu = awful.menu({ items = mymenu 
                        })

mylauncher = awful.widget.launcher({ image = beautiful.menu_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

-- {{{ Clock
-- Create a textclock widget
mytextclock = awful.widget.textclock("<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ƕ %I:%M %p </span></span>")
cal.register(mytextclock, "<b><u>%s</u></b>")

-- }}}

-- {{{ System
        local f, infos
        f = io.popen("yaourt -Qua")
        infos = f:read("*all")
        if (infos == '') then
            title = "No Updates"
        else
            title = "Updates"
        end
        f:close()
local function updates()
        showpac = naughty.notify({
                  text = infos,
                  title = title,
                  timeout	= 0,
                  hover_timeout = 0,
                  })
end
syswidget = wibox.widget.textbox()
vicious.register(syswidget, vicious.widgets.pkg, function (widget, args)
                                                 if (args[1] > 0) then
                                                 return "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ɔ " .. args[1] .. " </span></span>"
                                                 else
                                                 return ""
                                                 end end, 60, "Arch")
                                                 
syswidget:connect_signal('mouse::enter', function () updates(path) end)
syswidget:connect_signal('mouse::leave', function () naughty.destroy(showpac) end)
syswidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("urxvtc -e yaourt -Syua --noconfirm") end)))
 -- }}}
-- }}}

-- {{{ CPU
cpuwidget = wibox.widget.textbox()
cpu_t = awful.tooltip({ objects = { cpuwidget }, })
vicious.register(cpuwidget, vicious.widgets.cpu, 
function (widget, args)
cpu_t:set_text(args[1] .. "% " .. args[2] .. "% " .. args[3] .. "% " .. args[4] .. "%")
return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ə " .. args[1] .. "%</span></span>"
end, 3)
cpuwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(htop, false) end)))
-- }}}

-- {{{ Memory
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ƞ $1%</span></span>", 3)
memwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(htop, false) end)))
blingbling.popups.htop(memwidget, { title_color = beautiful.colors.blue , user_color = beautiful.colors.green , root_color = beautiful.colors.red , terminal =  terminal })
-- }}}
-- {{{ Net Widget
local wicd = require("wicd")

net = wibox.widget.textbox()
netwidget = nil
ip_addr=string.match(string.match(awful.util.pread("ip route show"),"%ssrc%s[%d]+%.[d%]+%.[%d]+%.[%d]+"), "[%d]+%.[d%]+%.[%d]+%.[%d]+")
gateway= string.match(string.match(awful.util.pread("ip route show"),"default%svia%s[%d]+%.[d%]+%.[%d]+%.[%d]+"), "[%d]+%.[d%]+%.[%d]+%.[%d]+")
ext_ip = awful.util.pread("curl --silent --connect-timeout 3 -S http://ipecho.net/plain 2>&1")

net_t = awful.tooltip({ objects = { net }})
vicious.register(net, vicious.widgets.wifi,
function (widget, args)
if args["{ssid}"] == "N/A" then
    netwidget = blingbling.net({interface = eth, show_text = true, background_color = beautiful.colors.base0, text_color = beautiful.colors.base03, graph_color = beautiful.colors.base03, graph_line_color = "#00000000", background_graph_color = beautiful.colors.base2, background_text_color = "#00000000", font = "termsyn", font_size = "11", label = "Ƥ"})
    net_t:set_text("Wired\nLAN IP: " .. ip_addr .. "\nGateway: " .. gateway .. "\nWAN IP: " .. ext_ip)
    return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ƥ </span></span>"
elseif args["{ssid}"] ~= "N/A" then
    netwidget = blingbling.net({interface = wlan, show_text = true, background_color = beautiful.colors.base0, text_color = beautiful.colors.base03, graph_color = beautiful.colors.base03, graph_line_color = "#00000000", background_graph_color = beautiful.colors.base2, background_text_color = "#00000000", font = "termsyn", font_size = "11", label = "ƥ"})
	net_t:set_text(args["{ssid}"] .. " " .. args["{linp}"] .. "%\nLAN IP: " .. ip_addr .. "\nGateway: " .. gateway .. "\nWAN IP: " .. ext_ip)
	if args["{linp}"] >= 75 then
         return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ƥ </span></span>"
    elseif args["{linp}"] >= 40 then
         return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ʀ </span></span>"
    elseif args["{linp}"] >= 20 then
         return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ƨ </span></span>"
    else
         return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ƨ </span></span>"
    end
else
    return "Off "
end
end, 10, wlan)
net_t:add_to_object(net)
net_t:add_to_object(netwidget)

netwidget:buttons(net:buttons(awful.util.table.join(awful.button({ }, 1, function () wicd.launch() end),
                                                    awful.button({ altkey }, 1, function () awful.util.spawn("wicd-client -n") end),
                                                    awful.button({ }, 3, function () wicd.toggle() end) )))

-- }}}

-- {{{ GMail widget
-- you need a .netrc file in your home directory filled with this:
-- machine mail.google.com login YOUR_MAIL password YOUR_PASS
mygmail = wibox.widget.textbox()
gmail_t = awful.tooltip({ objects = { mygmail },})
notify_shown = false
vicious.register(mygmail, vicious.widgets.gmail,
 function (widget, args)
  gmail_t:set_text(args["{subject}"])
  gmail_t:add_to_object(mygmail)
  notify_title = ""
  notify_text = ""
  if (args["{count}"] > 0 ) then
    if (notify_shown == false) then
      if (args["{count}"] == 1) then
          notify_title = "You got a new mail"
          notify_text = '"' .. args["{subject}"] .. '"'
      else
          notify_title = "You got " .. args["{count}"] .. " new mails"
          notify_text = 'Last one: "' .. args["{subject}"] .. '"'
      end
      naughty.notify({
          title = notify_title,
          text = notify_text,
          timeout = 7,
          position = "top_right",
      })
      notify_shown = true
    end
    return "<span background='" ..beautiful.colors.base0 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ɠ " .. args["{count}"] .. "</span></span>"
  else
    notify_shown = false
    return ''
  end
end, 60)
mygmail:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail, false) end)))
-- }}}

-- {{{ Volume
volwidget = wibox.widget.textbox()
vol_t = awful.tooltip({ objects = { volwidget, volume_master } })

volume_master = blingbling.volume({height = 18, graph_color = beautiful.colors.base03, graph_background_color = "#00000000", background_color = beautiful.colors.base1, width = 40, show_text = true, background_text_color = "#00000000", bar = false, label ="$percent%"})
volume_master:update_master()
volume_master:set_master_control()
vol_t:add_to_object(volume_master)

vicious.register( volwidget, vicious.widgets.volume, function(widget, args)
vol_t:set_text(args[1] .. "%")
vol_t:add_to_object(volwidget)
--local label = { ["♫"] = " ", ["♩"] = "M" }
    if (args[2] == "♩") then
    vol_t:set_text("Muted")
    return "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ʃ</span></span>"
    elseif (args[1] == 0) then
    return "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ƣ</span></span>"
    elseif (args[1] <= 30 and args[1] > 0) then
    return "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>Ƣ</span></span>"
    elseif (args[1] <= 60) then
    return "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ơ</span></span>"
    elseif (args[1] >= 61) then
    return "<span background='" ..beautiful.colors.base1 .. "' foreground='" .. beautiful.colors.base03 .. "' font='Tamsyn 15'> <span font='" .. beautiful.font .. "'>ƪ</span></span>"
    end
end, 1, "Master")

volmenu = awful.menu({ items = volume })

volwidget:buttons(volume_master:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(toggle_volume, false) end),
    awful.button({ }, 2, function () awful.util.spawn(volmixer, false) end),
    awful.button({ }, 3, function () volmenu:toggle() end),
    awful.button({ }, 4, function () awful.util.spawn(raise_volume, false) end),
    awful.button({ }, 5, function () awful.util.spawn(lower_volume, false) end)
)))

-- }}}
-- {{{ MPD
-- BEGIN OF AWESOMPD WIDGET DECLARATION

  local awesompd = require('awesompd.awesompd')

  musicwidget = awesompd:create() -- Create awesompd widget
  musicwidget.font = beautiful.font -- Set widget font 
  musicwidget.font_color = beautiful.colors.base03 --Set widget font color
  musicwidget.background = beautiful.colors.base0 --Set widget background color
  musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
  musicwidget.output_size = 30 -- Set the size of widget in symbols
  musicwidget.update_interval = 1 -- Set the update interval in seconds

  -- Set the folder where icons are located (change mony to your login name)
  musicwidget.path_to_icons = "/home/mony/.config/awesome/awesompd/icons" 

  -- Set the default music format for Jamendo streams. You can change
  -- this option on the fly in awesompd itself.
  -- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
  musicwidget.jamendo_format = awesompd.FORMAT_MP3
  
  -- Specify the browser you use so awesompd can open links from
  -- Jamendo in it.
  musicwidget.browser = browser

  -- If true, song notifications for Jamendo tracks and local tracks
  -- will also contain album cover image.
  musicwidget.show_album_cover = true

  -- Specify how big in pixels should an album cover be. Maximum value
  -- is 100.
  musicwidget.album_cover_size = 50
  
  -- This option is necessary if you want the album covers to be shown
  -- for your local tracks.
  musicwidget.mpd_config = "/home/mony/.mpdconf"
  
  -- Specify decorators on the left and the right side of the
  -- widget. Or just leave empty strings if you decorate the widget
  -- from outside.
  musicwidget.ldecorator = "Ǝ "
  musicwidget.rdecorator = " "

  -- Set all the servers to work with (here can be any servers you use)
  musicwidget.servers = {
     { server = "localhost",
          port = 6600 },
     { server = "192.168.0.72",
          port = 6600 }
  }

  -- Set the buttons of the widget. Keyboard keys are working in the
  -- entire Awesome environment. Also look at the line 352.
  musicwidget:register_buttons({ { "", awesompd.MOUSE_LEFT, musicwidget:command_playpause() },
     			       { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
  			       { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
  			       { "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
  			       { "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
  			       { "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
                               --{ "", "XF86_AudioLowerVolume", musicwidget:command_volume_down() },
                               --{ "", "XF86_AudioRaiseVolume", musicwidget:command_volume_up() },
                               { modkey, "Pause", musicwidget:command_playpause() } })

  musicwidget:run() -- After all configuration is done, run the widget

-- END OF AWESOMPD WIDGET DECLARATION
-- }}}

-- {{{ Keyboard layout
xkbw = wibox.widget.textbox()
bashets.register("xkb.sh", {widget = xkbw, update_time = 1, format = "<span foreground='" .. beautiful.fg_focus .. "'>$1</span>"})
xkbw:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("xkb-switch -n", false) end)))
-- }}}

-- {{{ Spacers & Arrows

rbracket = wibox.widget.textbox()
rbracket:set_text("]")
lbracket = wibox.widget.textbox()
lbracket:set_text("[")
line = wibox.widget.textbox()
line:set_text("|")
space = wibox.widget.textbox()
space:set_text(" ")
----------------------
rtar = wibox.widget.textbox()
rtar:set_markup("<span foreground='" .. beautiful.fg_focus .. "'>ƛ</span>")
rtar:buttons(awful.util.table.join(awful.button({ }, 1, function () mymainmenu:toggle() end)))
ltar = wibox.widget.textbox()
ltar:set_markup("<span foreground='" .. beautiful.fg_focus .. "'> Ɲ</span>")
arrr = wibox.widget.imagebox()
arrr:set_image(icons .. "/arrows/arrr.png")
arrl = wibox.widget.imagebox()
arrl:set_image(icons .. "/arrows/arrl.png")
arr1 = wibox.widget.imagebox()
arr1:set_image(icons .. "/arrows/arr1.png")
arr2 = wibox.widget.imagebox()
arr2:set_image(icons .. "/arrows/arr2.png")
arr3 = wibox.widget.imagebox()
arr3:set_image(icons .. "/arrows/arr3.png")
arr4 = wibox.widget.imagebox()
arr4:set_image(icons .. "/arrows/arr4.png")
arr5 = wibox.widget.imagebox()
arr5:set_image(icons .. "/arrows/arr5.png")
arr6 = wibox.widget.imagebox()
arr6:set_image(icons .. "/arrows/arr6.png")
arr7 = wibox.widget.imagebox()
arr7:set_image(icons .. "/arrows/arr7.png")
arr8 = wibox.widget.imagebox()
arr8:set_image(icons .. "/arrows/arr8.png")
arr9 = wibox.widget.imagebox()
arr9:set_image(icons .. "/arrows/arr9.png")
arr10 = wibox.widget.imagebox()
arr10:set_image(icons .. "/arrows/arr10.png")
arr11 = wibox.widget.imagebox()
arr11:set_image(icons .. "/arrows/arr11.png")
arr12 = wibox.widget.imagebox()
arr12:set_image(icons .. "/arrows/arr12.png")
arr13 = wibox.widget.imagebox()
arr13:set_image(icons .. "/arrows/arr13.png")
arr14 = wibox.widget.imagebox()
arr14:set_image(icons .. "/arrows/arr14.png")
arr15 = wibox.widget.imagebox()
arr15:set_image(icons .. "/arrows/arr15.png")
arr16 = wibox.widget.imagebox()
arr16:set_image(icons .. "/arrows/arr16.png")
-- }}}

bashets.start() -- start bashets

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill()                         end),
                     awful.button({ }, 3, function (c)
                                              client.focus = c
                                              if instance then
                                                   instance:hide()
                                                   instance = nil
                                              else
                                                   instance = showNavMenu()
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the top wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18, fg = theme.fg_normal })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(arr16)
    left_layout:add(mylayoutbox[s])
    left_layout:add(arr16)
    left_layout:add(mypromptbox[s]) 

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(arr15)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(space)
    right_layout:add(xkbw)
    right_layout:add(arr14)
    right_layout:add(musicwidget.widget)
    right_layout:add(arr7)
    right_layout:add(volwidget)
    right_layout:add(volume_master)
    right_layout:add(arr8)
    right_layout:add(mygmail)
    right_layout:add(net)
    right_layout:add(netwidget)
    right_layout:add(arr7)
    right_layout:add(memwidget)
    right_layout:add(arr8)
    right_layout:add(cpuwidget)
    right_layout:add(arr7)
    right_layout:add(syswidget)
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
    awful.button({ modkey }, 5,
        function ()
            local allclients = client.get(mouse.screen)

            for _,c in ipairs(allclients) do
                if c.minimized and c:tags()[mouse.screen] ==
    awful.tag.selected(mouse.screen) then
                    c.minimized = false
                    client.focus = c
                    c:raise()
                    return
                end
            end
        end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Up",   function () awful.layout.inc(layouts, 1) end       ),
    awful.key({ modkey,           }, "Down",  function () awful.layout.inc(layouts, -1) end       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey }, "e", revelation), -- Revelation
    
            -- unminimize windows
    awful.key({ modkey, "Shift"   }, "n",
        function ()
            local allclients = client.get(mouse.screen)

            for _,c in ipairs(allclients) do
                if c.minimized and c:tags()[mouse.screen] ==
    awful.tag.selected(mouse.screen) then
                    c.minimized = false
                    client.focus = c
                    c:raise()
                    return
                end
            end
        end),
    
    -- Screen focus
     awful.key({modkey,            }, "F1",     function () awful.screen.focus(1) end),
     awful.key({modkey,            }, "F2",     function () awful.screen.focus(2) end),
     
    -- Clients focus
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    
    -- Move & Resize
    awful.key({ altkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ altkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ altkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ altkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
    
        -- Media keys
    awful.key({ }, "XF86_AudioLowerVolume", function() awful.util.spawn(lower_volume) end ),
    awful.key({ }, "XF86_AudioRaiseVolume", function() awful.util.spawn(raise_volume) end ),
    awful.key({ }, "XF86_AudioMute", function() awful.util.spawn(toggle_volume) end ),
    awful.key({ }, "XF86_AudioPrev", function() awful.util.spawn(prev_music) end ),
    awful.key({ }, "XF86_AudioNext", function() awful.util.spawn(next_music) end ),
    awful.key({ }, "XF86_AudioPlay", function() awful.util.spawn(toggle_play) end ),

        -- Apps
    awful.key({ modkey }, "XF86Calculator", function() awful.util.spawn(calc) end ),
    awful.key({ }, "F12", function () scratch.drop(terminal .. " -depth 32 -bg rgba:0000/2b00/3600/deff", "top", "center", 0.80, 0.40, true) end),
    awful.key({ altkey,           }, "F4", function() awful.util.spawn("xkill") end), -- xkill
    awful.key({ }, "XF86HomePage", function() awful.util.spawn(browser) end ),
    awful.key({ }, "XF86Mail", function() awful.util.spawn(mail) end ),
    
        -- Menus
    awful.key({ modkey,           }, "space", function () mymainmenu:show() end),
    awful.key({ altkey }, "Tab", function () awful.menu.clients() end),
       
    -- Toggle mouse screen wibox
    awful.key({ modkey }, "b", function ()
     mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
     --mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Shift"   }, "Tab",
        function ()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(1)
           if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ altkey, "Control"   }, "l", function () awful.util.spawn(lock) end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- Run or raise applications with dmenu
    awful.key({ altkey }, "F2",
    function ()
        local f_reader = io.popen( dmenu)
        local command = assert(f_reader:read('*a'))
        f_reader:close()
        if command == "" then return end

    -- Check throught the clients if the class match the command
    local lower_command=string.lower(command)
    for k, c in pairs(client.get()) do
        local class=string.lower(c.class)
        if string.match(class, lower_command) then
            for i, v in ipairs(c:tags()) do
                awful.tag.viewonly(v)
                c:raise()
                c.minimized = false
                return
            end
        end
    end
    awful.util.spawn(command)
    end),
    -- Run in terminal
    awful.key({ modkey, "Shift"   }, "r",
          function ()
              awful.prompt.run({ prompt = "Run in terminal: " },
                  mypromptbox[mouse.screen].widget,
                  function (...) awful.util.spawn(terminal .. " -e " .. ...) end,
                  awful.completion.shell,
                  awful.util.getdir("cache") .. "/history")
          end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
        awful.key({ modkey }, "s", function ()
        awful.prompt.run({ prompt = "Web search: " }, mypromptbox[mouse.screen].widget,
            function (command)
                awful.util.spawn("firefox 'http://yubnub.org/parser/parse?command="..command.."'", false)
                -- Switch to the web tag, where Firefox is, in this case tag 3
                if tags[2][1] then awful.tag.viewonly(tags[2][1]) end
            end)
    end),
    
    awful.key({ }, "XF86Calculator", function ()
        awful.prompt.run({ prompt = "Calculate: " }, mypromptbox[mouse.screen].widget,
            function (expr)
                local result = awful.util.eval("return (" .. expr .. ")")
                naughty.notify({ text = expr .. " = " .. result, timeout = 10 })
            end
        )
    end),

    -- Menubar
    awful.key({ modkey }, "w", function() menubar.show() end),
    
    -- Print Screen
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/ 2>/dev/null'") end),

    -- Escape from keyboard focus trap (eg Flash plugin in Firefox)
    awful.key({ modkey, "Control" }, "Escape", function ()
         awful.util.spawn("xdotool getactivewindow mousemove --window %1 0 0 click --clearmodifiers 2")
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      function(c) awful.client.movetoscreen(c,c.screen-1) end ),
    awful.key({ modkey,           }, "p",      function(c) awful.client.movetoscreen(c,c.screen+1) end ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    
    -- Move window to next/prev tag
     awful.key({ modkey, "Shift"   }, "Left",
        function (c)
          local curidx = awful.tag.getidx()
          if curidx == 1 then
              awful.client.movetotag(tags[client.focus.screen][6])
          else
              awful.client.movetotag(tags[client.focus.screen][curidx - 1])
          end
        end),
          awful.key({ modkey, "Shift"   }, "Right",
          function (c)
            local curidx = awful.tag.getidx()
          if curidx == 9 then
              awful.client.movetotag(tags[client.focus.screen][1])
          else
              awful.client.movetotag(tags[client.focus.screen][curidx + 1])
          end
        end),
        
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
   
   -- Move client to monitor
   awful.key({ modkey, "Shift"   }, "F1", function (c) awful.client.movetoscreen(c, 1) end),
   awful.key({ modkey, "Shift"   }, "F2", function (c) awful.client.movetoscreen(c, 2) end),
   
   -- alt space
   awful.key({ altkey,           }, "space", function () showNavMenu() end)
        
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 2, function (c) c:kill()                         end),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ modkey }, 5,
        function ()
            local allclients = client.get(mouse.screen)

            for _,c in ipairs(allclients) do
                if c.minimized and c:tags()[mouse.screen] ==
    awful.tag.selected(mouse.screen) then
                    c.minimized = false
                    client.focus = c
                    c:raise()
                    return
                end
            end
        end),
    awful.button({ modkey }, 4, function (c) c.minimized = true end),
    
        -- Transparency
    awful.button({ altkey }, 4, function (c)
        awful.util.spawn("transset-df --actual --inc 0.1")
    end),
    awful.button({ altkey }, 5, function (c)
        awful.util.spawn("transset-df --actual --dec 0.1")
    end))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys, 
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons } },
    { rule_any = { class = { "MPlayer", "Umplayer", "Smplayer", "Vlc" } },
      properties = { tag = tags[2][2], floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[1][6], maximized = true } },
    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false } },
    { rule_any = { class = { "Eclipse", "Geany" } },
      properties = { tag = tags[1][4] } },
    { rule_any = { class = { "libreoffice-startcenter", "libreoffice-writer", "libreoffice-calc", "libreoffice-impress", "libreoffice-base", "libreoffice-draw", "libreoffice-math" } },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Galculator" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
     properties = { floating = true } },
    { rule = { instance = "exe" },
     properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" }, except_any = { instance = { "Dialog", "Browser" } },
     properties = { tag = tags[2][1], floating = false, border_width = 0 } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
            awful.placement.centered(c)
            --awful.placement.under_mouse(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
