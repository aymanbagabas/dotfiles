---------------------------
------    mony960    ------
---------------------------
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
local eminent = require("eminent")
local vicious = require("vicious")
local scratch = require("scratch")
local myplacesmenu = require("myplacesmenu")
local freedesktop = require('freedesktop')
local revelation = require("revelation")
local ipairs = ipairs
local pairs = pairs
local capi = {
     screen = screen,
     tag = tag,
     timer = timer,
     mouse = mouse,
     client = client,
     keygrabber = keygrabber
     }

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
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
-- Themes define colours, icons, and wallpapers
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"
icons = confdir .. "/icons"
_theme = themes .. "/p"
beautiful.init(_theme .. "/theme.lua")
_icons = _theme .. "/icons"

-- {{{ Autorun

function run_once(prg)
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

run_once("parcellite -n")
run_once("compton --config ~/.compton.conf -b")
run_once("nitrogen --restore")
run_once("wmname LG3D")

awful.util.spawn_with_shell("unagi &")
-- }}}

-- Helpers
function join_tables(t1, t2) for k,v in ipairs(t2) do table.insert(t1, v) end return t1 end

function xrandr_screens ()
    local screens = {}
    local counter = 1
    local handle = io.popen("xrandr -q")
    for display in handle:read("*all"):gmatch("([%a%d-]+) connected") do
        screens[counter] = display
        counter = counter + 1
    end
    handle:close()
    return screens
end
screens = xrandr_screens()

function noti(args)
	naughty.notify(args)
end

-- This is used later as the default terminal and editor to run.
terminal = "urxvtq -name Terminal"
smlterm = terminal .. " -depth 32 -bg rgba:0000/2b00/3600/deff -geometry 50x11 -name smlterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
dmenu = "dmenu_path_c | dmenu -i -p 'Run command:' -h '24' -fn '" .. beautiful.dfont .. "' -nb '#000000' -nf '" .. beautiful.fg_normal .. "' -sb '#919AA1' -sf '#605678'"
fileman = "nemo --no-desktop"
filemancli = terminal .. " -e ranger"
browser = "firefox"
browsercli = terminal .. " -e w3m"
mail = "thunderbird"
mailcli = terminal .. " -e mutt"
calc = "galculator"
htop = terminal .. " -name htop -e htop"
sysmon = "mate-system-monitor"
lock = "slimlock"

volmixer = terminal .. " -name alsamixer -e alsamixer"
mpdplr = terminal .. " -name ncmpcpp -e ncmpcpp"
mpdgui = "sonata"
mpd_lower_volume = "mpc volume -2"
mpd_raise_volume = "mpc volume +2"
lower_volume = "amixer -q set Master 2%- unmute"
raise_volume = "amixer -q set Master 2%+ unmute"
toggle_volume = "amixer set Master toggle"
prev_music = "mpc prev"
next_music = "mpc next"
toggle_play = "mpc toggle"
stop_music = "mpc stop"

eth = "eth0"
wlan = "wlan0"

-- Settings
titlebars = false
titlebar_on_floating = true
-- freedesktop settings
freedesktop.utils.terminal = terminal  -- default: "xterm"
freedesktop.desktop.config.computer = true
freedesktop.desktop.config.home = true
freedesktop.desktop.config.trash = true
freedesktop.desktop.config.network = false
-- Add desktop Icons
for s = 1, screen.count() do
        freedesktop.desktop.add_desktop_icons({screen = s, showlabels = true, open_with = 'xdg-open'})
end

-- Naughty
naughty.config.defaults.timeout = 5
naughty.config.defaults.margin = "5"
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.border_width = 1
naughty.config.defaults.border_color = beautiful.tooltip_border_color
naughty.config.defaults.bg = beautiful.tooltip_bg_color or '#535d6c'
naughty.config.defaults.fg = beautiful.tooltip_fg_color or '#ffffff'

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
    awful.layout.suit.floating, --1
    awful.layout.suit.tile, --2
    awful.layout.suit.tile.left, --3
    awful.layout.suit.tile.bottom, --4
    awful.layout.suit.tile.top, --5
    awful.layout.suit.fair, --6
    awful.layout.suit.fair.horizontal, --7
    awful.layout.suit.spiral, --8
    awful.layout.suit.spiral.dwindle, --9
    awful.layout.suit.max, --10
    awful.layout.suit.max.fullscreen, --11
    awful.layout.suit.magnifier --12
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

revelation.config.tag_name = 'R'

tags = {
    settings = {
    { 
    names = { "1", "2", "3", "4" },
    icons = { _icons .. "/white/arch.png", _icons .. "/white/dish.png", _icons .. "/white/info_03.png" }, 
    sep = { nil, _icons .. "/arrow.png", _icons .. "/arrow.png" },
    layouts = { layouts[2], layouts[10], layouts[9], layouts[1] } 
    },
    {
    names = { "5", "6", "7", "8" },
    icons = { _icons .. "/white/fox.png", _icons .. "/white/empty.png" },
    sep = { nil, _icons .. "/arrow.png"},
    layouts = { layouts[11], layouts[6], layouts[12], layouts[1] }
    }}}
for s = 1, screen.count() do
local tag = {}
    
    -- Each screen has its own tag table.
      tags[s] = awful.tag(tags.settings[s].names, s, tags.settings[s].layouts)
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

function mvscr(c)
     local scrs = {}
     for s = 1, capi.screen.count() do
     scrs[s] = { s, function () awful.client.movetoscreen(c, s) end }
     end
     return scrs
end

function tag(func, c)
     local tags_n = {}
     for t = 1, #awful.tag.gettags(c.screen) do
     tags_n[t] = { t, function() func(awful.tag.gettags(c.screen)[t], c) end }
     end
     return tags_n
end

function clsmenu()
    local cls = capi.client.get()
    local cls_t = {}
    for k, c in pairs(cls) do
        cls_t[#cls_t + 1] = {
            awful.util.escape(c.name) or "",
            function ()
                if not c:isvisible() then
                    awful.tag.viewmore(c:tags(), c.screen)
                end
                if c.minimized then
                    c.minimized = not c.minimized
                end
                capi.client.focus = c
                c:raise()
                awful.screen.focus(c.screen)
            end,
            c.icon }
    end
    return cls_t
end

function setlay(c, arg) -- FIXME set layout for selected client tag
         local lay_m = {}
         for s = 1, #arg do
         lay_m[s] = { awful.layout.getname(arg[s]), function () awful.layout.set(arg[s], awful.tag.selected(c.screen)) end, beautiful["layout_" .. awful.layout.getname(arg[s])] }
         end
         return lay_m
end

function ClientMenu(c, args)

local args = args or {}
c = c or capi.client.focus
local menu = {}
menu.fclient = {
        {"Close", function() c:kill() end},
        {(c.minimized and "Restore") or "Minimize", function() c.minimized = not c.minimized end},	
        {(c.fullscreen and "Restore") or "Fullscreen", function () c.fullscreen = not c.fullscreen  end},
        {(c.maximized_horizontal and "Restore") or "Maximize", function () c.maximized_horizontal = not c.maximized_horizontal c.maximized_vertical = not c.maximized_vertical end},
        {(c.sticky and "Un-Stick") or "Stick", function() c.sticky = not c.sticky end},
        {(c.ontop and "Offtop") or "Ontop", function() c.ontop = not c.ontop if c.ontop then c:raise() end end},
        {((awful.client.floating.get(c) and "Tile") or "Float"), function() awful.client.floating.toggle(c) end},
        {"Set Master", function() c:swap(awful.client.getmaster(1)) end},
        {"Set Slave",function() awful.client.setslave(c) end},
        {(awful.client.property.get(c, "titlebar") and "Remove titlebar") or "Add titlebar",
            function() 
            if awful.client.property.get(c, "titlebar") then
                remove_titlebar(c)
            else
                add_titlebar(c)
            end end}}
menu.mynav = {
        { "<b>" .. awful.util.escape(c.class) .. "</b>",
            menu.fclient, c.icon},
        { " ", function () c_menu:hide() end},
        {"Move to Tag", tag(awful.client.movetotag, c)},
        {"Toggle Tag", tag(awful.client.toggletag, c)},
        {"Move to Screen", mvscr(c)},
        {"Set tag layout", setlay(c, layouts)},
        {"Running Clients", clsmenu()},}
args.items = menu.mynav

c_menu = awful.menu(args)
return c_menu
end

myawesomemenu = {
   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd .. " " .. awesome.conffile, freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
   { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
}

exitmenu = {
   { "Shutdown", "poweroff", freedesktop.utils.lookup_icon({ icon='system-shutdown' }) },
   { "Restart", "reboot", freedesktop.utils.lookup_icon({ icon='view-refresh' }) },
   { "Lock", "slimlock", freedesktop.utils.lookup_icon({ icon='system-lock-screen' }) },
   { "awesome", myawesomemenu, beautiful.awesome_icon }
}

volume = {
   { "Un/Mute", "amixer set Master toggle", freedesktop.utils.lookup_icon({ icon='audio-volume-muted' }) },
   { "30%", "amixer set Master 30%", freedesktop.utils.lookup_icon({ icon='audio-volume-low' }) },
   { "50%", "amixer set Master 50%", freedesktop.utils.lookup_icon({ icon='audio-volume-low' }) },
   { "80%", "amixer set Master 80%", freedesktop.utils.lookup_icon({ icon='audio-volume-medium' }) },
   { "100%", "amixer set Master 100%", freedesktop.utils.lookup_icon({ icon='audio-volume-high' }) },
   { "Mixer", volmixer }
}

musicmenu = {
   { "Play/Pause", "mpc toggle", freedesktop.utils.lookup_icon({ icon='stock_media-play' }) },
   { "Stop", "mpc stop", freedesktop.utils.lookup_icon({ icon='stock_media-stop' }) },
   { "Previous", "mpc prev", freedesktop.utils.lookup_icon({ icon='stock_media-prev' }) },
   { "Next", "mpc next", freedesktop.utils.lookup_icon({ icon='stock_media-next' }) },
   { "CLI", mpdplr, freedesktop.utils.lookup_icon({ icon='multimedia-volume-control' }) },
   { "GUI", mpdgui, freedesktop.utils.lookup_icon({ icon='multimedia-volume-control' }) },
   { "Volume", volume, freedesktop.utils.lookup_icon({ icon='stock_volume' }) }

}

beautiful.default_app_icon = freedesktop.utils.lookup_icon({ icon='application-default-icon' })

mymainmenu = awful.menu({ items = awful.util.table.join({
                                    { "&File Manager", fileman, freedesktop.utils.lookup_icon({ icon='file-manager' }) },
                                    { "&Browser", browser, freedesktop.utils.lookup_icon({ icon='browser' }) },
                                    { "&Terminal", terminal, freedesktop.utils.lookup_icon({ icon='terminal' }) },
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil},
                                    { "Files", myplacesmenu.genMenu(os.getenv('HOME') .. '/'), freedesktop.utils.lookup_icon({ icon='folder-home' }) },
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil}
                                    },
                                    freedesktop.menu.new(),
                                    {
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil},
                                    { "Music", musicmenu, freedesktop.utils.lookup_icon({ icon='multimedia-volume-control' }) },
                                    { " ", function () awful.menu.hide(mymainmenu) end, nil},
                                    { "Exit", exitmenu, freedesktop.utils.lookup_icon({ icon='exit' }) }})
})

mylauncher = awful.widget.launcher({ image = beautiful.menu_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

mpdbuttons = {}
buttons = {}
mpdstate = {}
mailwidget = {}
memwidget = {}
syswidget = {}
cpuwidget = {}
pkgwidget = {}
netwidget = {}

for s = 1, screen.count() do

	bg_left = wibox.widget.imagebox()
	bg_left:set_image(beautiful.bg_left)
	bg_right = wibox.widget.imagebox()
	bg_right:set_image(beautiful.bg_right)
	spr = wibox.widget.imagebox()
	spr:set_image(beautiful.separator)
	
	tb_bg_left = wibox.widget.imagebox()
	tb_bg_left:set_image(beautiful.titlebar_left)
	tb_bg_right = wibox.widget.imagebox()
	tb_bg_right:set_image(beautiful.titlebar_right)
	
	tag_end = wibox.widget.imagebox()
	tag_end:set_image(beautiful.tag_end)
	
	space = wibox.widget.textbox()
	space:set_text(" ")
	
	close = wibox.widget.imagebox()
	close:buttons(awful.button({ }, 1, function () c = capi.client.focus 
		if c and c.screen == mouse.screen then 
			c:kill()
		end 
	end, function () c = capi.client.focus if not c then buttons[s]:set_widget(nil) end end))
	close:set_image(beautiful.titlebar_close_button_normal)
	maxi = wibox.widget.imagebox()
	maxi:buttons(awful.button({ }, 1, function () c = capi.client.focus
		if c and c.screen == mouse.screen then 
			c.maximized_horizontal = not c.maximized_horizontal c.maximized_vertical = not c.maximized_vertical 
		end
	end, function () if not client.focus then buttons[s]:set_widget(nil) end end))
	maxi:set_image(beautiful.titlebar_maximized_button_active)
	mini = wibox.widget.imagebox()
	mini:buttons(awful.button({ }, 1, function () c = capi.client.focus 
		if c and c.screen == mouse.screen then
			c.minimized = not c.minimized
		end
	end, function () if not client.focus then buttons[s]:set_widget(nil) end end))
	mini:set_image(beautiful.titlebar_minimize_button_inactive) 
	
	but_lay = wibox.layout.fixed.horizontal()
	but_lay:add(mini)
	but_lay:add(maxi)
	but_lay:add(close)
	buttons[s] = wibox.layout.margin() -- FIXME hide it if no focused client
	
	play = wibox.widget.imagebox()
	play:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell(toggle_play) end))
	prev = wibox.widget.imagebox()
	prev:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell(prev_music) end))
	next = wibox.widget.imagebox()
	next:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell(next_music) end))
	stop = wibox.widget.imagebox()
	stop:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell(stop_music) end))
	play:set_image(beautiful.mpd_play)
	next:set_image(beautiful.mpd_next)
	prev:set_image(beautiful.mpd_prev) 
	stop:set_image(beautiful.mpd_stop) 
	
	mpd_lay = wibox.layout.fixed.horizontal()
	mpd_lay:add(prev)
	mpd_lay:add(stop)
	mpd_lay:add(play)
	mpd_lay:add(next)
	mpdbuttons[s] = wibox.layout.margin()
	
	local cal = require("cal")
	mytextclock = awful.widget.textclock("<span background='#919AA1' font='Tamsyn 10' > <span font='"..beautiful.font.."' color='#E7E4C4'>Time: <span color='#605678'>%I:%M %p </span></span></span>")
	cal.register(mytextclock, "<span background='#E7E4C4' color='#919aa1'><b>%s</b></span>", 1)
	clockwidget = wibox.layout.margin(mytextclock)
	
	syswid = wibox.widget.textbox()
	vicious.register(syswid, vicious.widgets.os, "<span background='#919AA1' font='Tamsyn 10' > <span font='"..beautiful.font.."' color='#E7E4C4'>System: <span color='#605678'>$2 </span></span></span>", 20)
	sys_t = awful.tooltip({ objects = {syswid}, timeout = 1, timer_function = function () local cpu = vicious.widgets.cpu() local mem = vicious.widgets.mem()
				return " <span color='#605678'>CPU: </span>"..cpu[1].."% "..cpu[2].."% "..cpu[3].."% "..cpu[4]..
				"% \n <span color='#605678'>Memory: </span>"..mem[2].." Mb / "..mem[3].." Mb \n\n"..
				string.gsub(awful.util.pread("ps --sort -c,-s -eo pid,user,s,%cpu,%mem,bsdtime,etime,comm | head -n 8"), "^(.-)\n", "<span color='#605678'>%1</span>\n").." \n"..
				string.gsub(awful.util.pread("df -h"), "^(.-)\n", "<span color='#605678'>%1</span>\n")
	end})
	
	sys_lay = wibox.layout.fixed.horizontal()
	sys_lay:add(syswid)
	sys_lay:add(spr)
	syswidget[s] = wibox.layout.margin()
	
	pkgwid = wibox.widget.textbox()
	pkg_lay = wibox.layout.fixed.horizontal()
	pkg_lay:add(pkgwid)
	pkg_lay:add(spr)
	pkgwidget[s] = wibox.layout.margin(pkg_lay)
	pkg_t = awful.tooltip({ objects = { pkgwid }})
	noti_shown = false
	hidepkgs = true
	pkgs = 0
	vicious.register(pkgwid, vicious.widgets.pkg, function (widget, args)
		 local updates = awful.util.pread("pacman -Qu")
		 if (args[1] > 0) then
			pkgwidget[s]:set_widget(pkg_lay)
			pkg_t:set_text("<b>Updates: </b>\n"..updates.."\n<b>Click to Update</b>")
			if not noti_shown then
			 naughty.notify({
			 text = updates,
			 title = "Updates:",
			 position = "top_right",
			 timeout = 10
			 })
			noti_shown = true
			end
		 else
			 noti_shown = false
			 if hidepkgs then
				pkgwidget[s]:set_widget(nil)
			 end
			 pkg_t:set_text(" No Updates ")
		 end 
		 pkgs = args[1]
		 return "<span background='#919AA1' font='Tamsyn 10' > <span font='"..beautiful.font.."' color='#E7E4C4'>Updates: <span color='#605678'>".. args[1] .. " </span></span></span>"
	end, 180, "Arch")
	pkgwid:buttons(awful.button({ }, 1, function () awful.util.spawn("gksudo '" .. terminal .. " -name Updates -e yaourt -Syua --noconfirm'") end))
	
	netwid = wibox.widget.textbox()
	net_t = awful.tooltip({ objects = {netwid}})
	net_lay = wibox.layout.fixed.horizontal()
	net_lay:add(netwid)
	net_lay:add(spr)
	netwidget[s] = wibox.layout.margin()
	vicious.register(netwid, vicious.widgets.net, function(widget, args)
		if args["{"..wlan.." carrier}"] == 1 then
			int = wlan
		elseif args["{"..eth.." carrier}"] == 1 then
			int = eth
		else
			int = nil
		end
		if int then 
			if tonumber(args["{"..int.." up_kb}"]) > 0 then
				up = "<b>↑</b>"
			else
				up = "<span color='#737A80'><b>↑</b></span>"
			end
			if tonumber(args["{"..int.." down_kb}"]) > 0 then
				down = "<b>↓</b>"
			else
				down = "<span color='#737A80'><b>↓</b></span>"
			end
			net_t:set_text(" <span color='#605678'>Interface: </span>"..int..
			" \n <span color='#605678'>Up: </span>"..args["{"..int.." up_kb}"]..
			" Kb \n <span color='#605678'>Down: </span>"..args["{"..int.." down_kb}"].." Kb ")
		else
			up = "<span color='#737A80'>↑</span>"
			down = "<span color='#737A80'>↓</span>"
			net_t:set_text(" <span color='#605678'>Interface: </span>Disconnected ")
		end
		return "<span background='#919AA1' font='Tamsyn 10' > <span font='"..beautiful.font.."' color='#E7E4C4'>Net: <span color='#605678'>"..up..down.." </span></span></span>"
			
	end, 1)
	
	-- GMail widget
	-- you need a .netrc file in your home directory filled with this:
	-- machine mail.google.com login YOUR_MAIL password YOUR_PASS
	mygmail = wibox.widget.textbox()
	mail_lay = wibox.layout.fixed.horizontal()
	mail_lay:add(mygmail)
	mail_lay:add(spr)
	mailwidget[s] = wibox.layout.margin()
	gmail_t = awful.tooltip({ objects = { mygmail }})
	g_notify = false
	hidemail = true
	mails = 0
	vicious.register(mygmail, vicious.widgets.gmail,
	 function (widget, args)
	  notify_title = ""
	  notify_text = ""
	  if (args["{count}"] > 0 ) then
		mailwidget[s]:set_widget(mail_lay)
	    gmail_t:set_text(" "..args["{subject}"].." ")
	    if (g_notify == false) then
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
	          position = "top_left",
	      })
	      g_notify = true
	    end
	  else
	    gmail_t:set_text(" No new mails ")
		if hidemail then
			mailwidget[s]:set_widget(nil)
		end
	    g_notify = false
	  end
	  mails = args["{count}"]
	  return "<span background='#919AA1' font='Tamsyn 10' > <span font='"..beautiful.font.."' color='#E7E4C4'>Mail: <span color='#605678'>" .. args["{count}"] .. " </span></span></span>"
	end, 61)
	mygmail:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail) end)))
	
	mpdstatus = wibox.widget.textbox()
	mpdwidget = wibox.widget.textbox()
	musicwidget = wibox.layout.margin(mpdwidget)
	mpdstate[s] = wibox.layout.margin()
	curr_track = nil
	vicious.register(mpdwidget, vicious.widgets.mpd,
	    function (widget, args)
	    if string.match(awful.util.pread('pgrep -x pianobar'), '(%d+)\n') then -- pianobar
				mpdstatus:set_markup("<span color='#E7E4C4'>pianobar</span>")
				stop_music = nil
				next_music = "echo -n 'n' > ~/.config/pianobar/ctl"
				toggle_play = "echo -n 'p' > ~/.config/pianobar/ctl"
				stop_music = "echo -n 'q' > ~/.config/pianobar/ctl"
				artist = awful.util.escape(awful.util.pread("cat ~/.config/pianobar/nowplaying | awk -F '\\' '{print $1}' | tr -d '\n'"))
				title = awful.util.escape(awful.util.pread("cat ~/.config/pianobar/nowplaying | awk -F '\\' '{print $2}' | tr -d '\n'"))
				album = awful.util.escape(awful.util.pread("cat ~/.config/pianobar/nowplaying | awk -F '\\' '{print $3}' | tr -d '\n'"))
				return "<span color='#919AA1'> " .. artist .. "</span> <span color='#76728B'>" .. title .. "</span>"
	    else
			prev_music = "mpc prev"
			next_music = "mpc next"
			toggle_play = "mpc toggle"
			stop_music = "mpc stop"
			artist = args["{Artist}"]
			title = args["{Title}"]
			album = args["{Album}"]
	        if args["{state}"] == "Play" then
				mpdstatus:set_markup("<span color='#E7E4C4'>Playing</span>")
				play:set_image(beautiful.mpd_pause)
	            if( args["{Title}"] ~= curr_track ) then
	            curr_track = args["{Title}"]
	            run_once("mpdinfo")
	            end
	            return "<span color='#919AA1'> " .. args["{Artist}"] .. "</span> <span color='#76728B'>" .. args["{Title}"] .. "</span>"
	        elseif args["{state}"] == "Pause" then
				mpdstatus:set_markup("<span color='#E7E4C4'>Paused</span>")
				play:set_image(beautiful.mpd_play)
	            return ""
	        elseif args["{state}"] == "Stop" then
				mpdstatus:set_markup("<span color='#E7E4C4'>Stopped</span>")
				play:set_image(beautiful.mpd_play)
	            return ""
	        else
				mpdstatus:set_markup("<span color='#E7E4C4'>"..args['{state}'].."</span>")
				play:set_image(beautiful.mpd_play)
	            return ""
	        end
	    end
	    end, 1)
	mpdwidget:buttons(awful.button({ }, 1, function () awful.util.spawn(mpdplr) end))
				
	mpdwidget:connect_signal("mouse::enter", function () mpdbuttons[mouse.screen]:set_widget(mpd_lay) end)
	mpdstatus:connect_signal("mouse::enter", function () mpdbuttons[mouse.screen]:set_widget(mpd_lay) end)
	
	volwidget = wibox.widget.textbox()
	vol_lay = wibox.layout.fixed.horizontal()
	vol_lay:add(volwidget)
	vol_lay:add(spr)
	volumewidget = wibox.layout.margin(vol_lay)
	vol_t = awful.tooltip({ objects = {volwidget}})
	vicious.register(volwidget, vicious.widgets.volume, function (widget, args)
			volume = args[1]
			if (args[2] == "♩") then vol = volume .. '% M' else vol = volume .. '%' end
			for i = 1, math.floor(volume / 10) do
				if i == 1 then text = "<span background='#605678'>-</span>" end
				if i == 4 and args[2] == "♩" then text = text.."<span background='#605678'>M</span>" end
				if i == 5 and args[2] == "♩" then text = text.."<span background='#605678'>u</span>" end
				if i == 6 and args[2] == "♩" then text = text.."<span background='#605678'>t</span>" end
				if i == 7 and args[2] == "♩" then text = text.."<span background='#605678'>e</span>" end
				text = text .. "<span background='#605678'> </span>"
				if i == 10 then text = text .. "<span background='#605678'>+</span>" end
			end
			for i = math.floor(volume / 10) + 1, 10 do
				if i == 1 then text = "-" end
				if i == 4 and args[2] == "♩" then text = text.."M" end
				if i == 5 and args[2] == "♩" then text = text.."u" end
				if i == 6 and args[2] == "♩" then text = text.."t" end
				if i == 7 and args[2] == "♩" then text = text.."e" end
				text = text .. " "
				if i == 10 then text = text .. "+" end
			end
			vol_t:set_text(text)
			return "<span background='#919AA1' font='Tamsyn 10' > <span font='"..beautiful.font.."' color='#E7E4C4'>Volume: <span color='#605678'>" .. vol .. " </span></span></span>"
	end, 10, "Master")
	volwidget:buttons(awful.util.table.join(
	    awful.button({ }, 1, function () awful.util.spawn(toggle_volume) vicious.force({volwidget}) end),
	    awful.button({ }, 4, function () awful.util.spawn(raise_volume) vicious.force({volwidget}) end),
	    awful.button({ }, 5, function () awful.util.spawn(lower_volume) vicious.force({volwidget}) end)))
	
end

mywibox = {}
reve = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 3, function () 
			                                  menu = {theme = {width = 300}}
			                                  menu.items = clsmenu()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu(menu)
				                                  instance:show()
                                              end end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
left_tasklist = {}
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
                     awful.button({ }, 2, function (c) c:kill() end),
                     awful.button({ }, 3, function (c)
	                                              if instance then
	                                                   instance:hide()
	                                                   instance = nil
	                                              else
	                                                   instance = ClientMenu(c, {theme = {width=200}})
	                                                   instance:show()
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
    mypromptbox[s] = awful.widget.prompt({prompt = " Run: "})
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 2, function () sel = capi.client.focus end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, function (c, screen)
                                                 if c.screen ~= screen then return false end
                                                 return awful.client.focus.history.get(screen, 0) == c
                                             end, mytasklist.buttons, {tasklist_disable_icon = true})

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 24 })
    mywibox[s]:connect_signal("mouse::enter", function (c) 
		  c = capi.client.focus
		  if c and c.screen == mouse.screen then
			buttons[mouse.screen]:set_widget(but_lay)
		  end 
		  mpdstate[mouse.screen]:set_widget(mpdstatus)
		  hidemail = false
		  hidepkgs = false
    end)
    mywibox[s]:connect_signal("mouse::leave", function () 
		  buttons[s]:set_widget(nil)
		  mpdbuttons[s]:set_widget(nil) 
		  mpdstate[s]:set_widget(nil)
		  syswidget[s]:set_widget(nil) 
		  netwidget[s]:set_widget(nil)
		  if pkgs == 0 then pkgwidget[s]:set_widget(nil) end 
		  if mails == 0 then mailwidget[s]:set_widget(nil) end  
		  hidemail = true
		  hidepkgs = true
    end)

	widgets_layout = wibox.layout.fixed.horizontal()
	widgets_layout:add(bg_left)
	widgets_layout:add(mailwidget[s])
	widgets_layout:add(pkgwidget[s])
	widgets_layout:add(syswidget[s])
	widgets_layout:add(netwidget[s])
	widgets_layout:add(volumewidget)
	widgets_layout:add(clockwidget)
	widgets_layout:add(bg_right)
	widgets = wibox.layout.margin(widgets_layout)
	widgets:connect_signal("mouse::enter", function () netwidget[mouse.screen]:set_widget(net_lay) syswidget[mouse.screen]:set_widget(sys_lay) pkgwidget[mouse.screen]:set_widget(pkg_lay) mailwidget[mouse.screen]:set_widget(mail_lay) end)

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(space)
    left_layout:add(tag_end)
    left_layout:add(mytaglist[s])
    left_layout:add(mylayoutbox[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(space)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(buttons[s])
    right_layout:add(space)
    right_layout:add(mpdstate[s])
    right_layout:add(musicwidget)
    right_layout:add(space)
    right_layout:add(mpdbuttons[s])
    right_layout:add(space)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(space)
    right_layout:add(widgets)
    right_layout:add(space)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    
    reve[s] = wibox({ x = capi.screen[s].geometry.x, y = capi.screen[s].geometry.height-1, width = 1, height = 1, visible = true, ontop = true, opacity = 0})
    reve[s]:connect_signal("mouse::enter", function () revelation() end)

end
-- }}}

 function fullscreens(c)
     awful.client.floating.toggle(c)
     if awful.client.floating.get(c) then
         local clientX = screen[1].workarea.x
         local clientY = screen[1].workarea.y
         local clientWidth = 0
         -- look at http://www.rpm.org/api/4.4.2.2/llimits_8h-source.html
         local clientHeight = 2147483640
         for s = 1, screen.count() do
             clientHeight = math.min(clientHeight, screen[s].workarea.height)
             clientWidth = clientWidth + screen[s].workarea.width
         end
         local t = c:geometry({x = clientX, y = clientY, width = clientWidth, height = clientHeight})
     else
         --apply the rules to this client so he can return to the right tag if there is a rule for that.
         awful.rules.apply(c)
     end
     -- focus our client
     client.focus = c
 end

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "h",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "l",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "e",      revelation               ), -- Revelation
    awful.key({ modkey,			  }, "s", 	   function () scratch.pad.toggle() end),

    awful.key({ modkey,           }, "Left",
        function ()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Up",
        function ()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Right",
        function ()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Down",
        function ()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "Left", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    
    -- Screen focus
     awful.key({modkey,            }, "F1",       function () awful.screen.focus(1) end),
     awful.key({modkey,            }, "F2",       function () awful.screen.focus(2) end),
     
    -- Menus
    awful.key({ modkey,           }, "space", function () mymainmenu:toggle() end),
    awful.key({ altkey            }, "Tab",   function () 
                                 menu = {theme = {width = 300}}
                                 menu.items = clsmenu()
                                 local m = awful.menu(menu)
                                 m:show() end),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ altkey, "Control" }, "l", function () awful.util.spawn(lock) end),

    awful.key({ altkey,           }, "Right",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ altkey,           }, "Left",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ altkey, "Shift"   }, "Left",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ altkey, "Shift"   }, "Right",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ altkey, "Control" }, "Left",     function () awful.tag.incncol( 1)         end),
    awful.key({ altkey, "Control" }, "Right",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "k",    function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey,           }, "j",  function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    
    awful.key({ modkey }, "XF86Calculator", function() awful.util.spawn(calc) end ),
    awful.key({ }, "F12", function () scratch.drop(terminal .. " -depth 32 -bg rgba:0000/0000/0000/8888", "top", "center", 0.80, 0, 0.40, 0, true) end),
    awful.key({ altkey,           }, "F4", function() awful.util.spawn("xkill") end), -- xkill
    awful.key({ }, "XF86HomePage", function() awful.util.spawn(browser) end ),
    awful.key({ }, "XF86Mail", function() awful.util.spawn(mail) end ),
    awful.key({ }, "Print", function () awful.util.spawn("scrot -q 100 -e 'mv $f ~/Pictures/ 2> /dev/null'") end),
    
    -- Media keys
    awful.key({ modkey }, "XF86_AudioLowerVolume", function() awful.util.spawn(mpd_lower_volume) end ),
    awful.key({ modkey }, "XF86_AudioRaiseVolume", function() awful.util.spawn(mpd_raise_volume) end ),
    awful.key({ }, "XF86_AudioLowerVolume", function() awful.util.spawn(lower_volume) vicious.force({volwidget}) end ),
    awful.key({ }, "XF86_AudioRaiseVolume", function() awful.util.spawn(raise_volume) vicious.force({volwidget}) end ),
    awful.key({ }, "XF86_AudioMute", function() awful.util.spawn(toggle_volume) vicious.force({volwidget}) end ),
    awful.key({ }, "XF86_AudioPrev", function() awful.util.spawn_with_shell(prev_music) end ),
    awful.key({ }, "XF86_AudioNext", function() awful.util.spawn_with_shell(next_music) end ),
    awful.key({ }, "XF86_AudioPlay", function() awful.util.spawn_with_shell(toggle_play) end ),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- Run or raise applications with dmenu
    awful.key({ altkey }, "F2",
    function ()
        local f_reader = io.popen(dmenu)
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
              awful.prompt.run({ prompt = " Run in terminal: " },
                  mypromptbox[mouse.screen].widget,
                  function (...) awful.util.spawn(terminal .. " -e " .. ...) end,
                  awful.completion.shell,
                  awful.util.getdir("cache") .. "/history")
          end),
    -- Calc
    awful.key({ }, "XF86Calculator", function ()
        awful.prompt.run({ prompt = " Calculate: " }, mypromptbox[mouse.screen].widget,
            function (expr)
                local result = awful.util.eval("return (" .. expr .. ")")
                naughty.notify({ text = expr .. " = " .. result, timeout = 15 })
                awful.prompt.history_save()
            end
        )
    end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = " Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "w", function() menubar.show() end),
    
    -- Escape from keyboard focus trap (eg Flash plugin in Firefox)
    awful.key({ modkey, "Control" }, "Escape", function ()
         awful.util.spawn("xdotool getactivewindow mousemove --window %1 0 0 click --clearmodifiers 2")
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,			  }, "d",	   function (c) scratch.pad.set(c, 0.60, 0.60, true) end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,  "Shift"  }, "f",      fullscreens                                      ),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      function(c) awful.client.movetoscreen(c,c.screen-1) end ),
    awful.key({ modkey,           }, "p",      function(c) awful.client.movetoscreen(c,c.screen+1) end ),
    awful.key({ modkey, "Shift"   }, "F1",     function (c) awful.client.movetoscreen(c, 1) end),
    awful.key({ modkey, "Shift"   }, "F2",     function (c) awful.client.movetoscreen(c, 2) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "y",      function (c) c.sticky = not c.sticky          end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),   
      
    -- Move floating windows
    awful.key({ modkey, altkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey, altkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey, altkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey, altkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey, altkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey, altkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
    
   -- Toggle titlebar
   awful.key({ modkey, "Shift" }, "t", function (c)
       if awful.client.property.get(c, "titlebar") then
           remove_titlebar(c)
       else
           add_titlebar(c)
       end
   end),
   
   -- Client menu
   awful.key({ altkey,           }, "space", function (c) geometry = c:geometry() instance = ClientMenu(c, {theme = {width=200}}) instance:show({coords={x=geometry.x+1,y=geometry.y+1}}) end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 2, function (c) c:kill() end),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
   -- Focus windows
	awful.button({ modkey }, 4, function ()
							  awful.client.focus.byidx(1)
							  if client.focus then client.focus:raise() end
						  end),
	awful.button({ modkey }, 5, function ()
							  awful.client.focus.byidx(-1)
							  if client.focus then client.focus:raise() end
						  end),
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
    -- Screen 1
    { rule = { instance = "Updates" },
      properties = { tag = tags[1][1] } },
    { rule_any = { class = { "Gimp-2.8", "libreoffice-startcenter", "libreoffice-writer", "libreoffice-calc", "libreoffice-impress", "libreoffice-base", "libreoffice-draw", "libreoffice-math" } },
      properties = { tag = tags[1][2], switchtotag = true } },
    { rule_any = { class = { "Eclipse", "Geany" } },
      properties = { tag = tags[1][3] } },
    -- Others
    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false, border_width = 0, titlebar = false } },
    { rule = { instance = "smlterm" }, callback = function(c) c:geometry({ x = 100, y = 100 }) end, -- FIXME set placement geometry
      properties = { floating = true, ontop = true, focus = true } },
    { rule_any = { class = { "Galculator", "Nitrogen", "Steam" ,"Gnome-mplayer", "Gcolor2", "feh", "Viewnior" }, instance = { "plugin-container", "exe", "file_progress" } },
      properties = { floating = true } },
}
if #screens > 1 then
scrs_rules = {
    -- Screen 2
    -- Set Firefox to always map on tags number 1 of screen 2.
    { rule = { class = "Firefox" }, except_any = { instance = { "Dialog", "Browser" } },
     properties = { tag = tags[2][1], fullscreen = true, floating = false, border_width = 0 } },
    { rule_any = { class = { "MPlayer", "Umplayer", "Smplayer", "Vlc", "Skype" } },
      properties = { tag = tags[2][4], floating = true } }, 
}
    join_tables(awful.rules.rules, scrs_rules)
end
-- }}}

function add_titlebar(c, args)
        args = args or {}
        args.size = beautiful.titlebar_size or 18
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        local tb_icon = awful.titlebar.widget.iconwidget(c)
        tb_icon:buttons(awful.button({ }, 1, function () 
                                              geometry = c:geometry()
                                              if instance then
                                                   instance:hide()
                                                   instance = nil
                                              else
                                                   instance = ClientMenu(c, {theme = {width=200}})
                                                   instance:show({coords={x=geometry.x+1,y=geometry.y+1}})
                                              end end))
        left_layout:add(tb_icon)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.button(c, "minimize", function () return c.minimized end, function() c.minimized = not c.minimized end))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        local function update_name() local c_name = awful.util.escape(c.name or "<unknown>") title:set_markup("<span background='#919AA1' font='Tamsyn 8'> <span font='"..beautiful.font.."'>"..c_name.."</span> </span>") end
        c:connect_signal("property::name", update_name)
        update_name()
        
        local title_layout = wibox.layout.fixed.horizontal()
        title_layout:add(tb_bg_left)
        title_layout:add(title)
        title_layout:add(tb_bg_right)
        
        title_layout:buttons(awful.util.table.join(
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
        layout:set_middle(title_layout)
        layout:set_right(right_layout)

        local titlebar = awful.titlebar(c, args)
        titlebar:set_widget(layout)
        awful.client.property.set(c, "titlebar", true)
end

function remove_titlebar(c)
        awful.titlebar(c, {size = 0})
        awful.client.property.set(c, "titlebar", false)
end

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
        end
    end

    -- Add titlebar to any floating window
    if titlebar_on_floating then
		if titlebar_on_floating and awful.client.floating.get(c) then
			add_titlebar(c)
		end
	    c:connect_signal("property::floating", function () 
			if awful.client.floating.get(c) then 
				if c.type == 'normal' then
					if c.class ~= "URxvt" then
						add_titlebar(c)
					end
				end
			else 
	            remove_titlebar(c)
	        end 
	    end)
    end
    local titlebars_enabled = titlebars or false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
       add_titlebar(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
