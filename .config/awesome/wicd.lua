local awful = require "awful"
local io = require "io"
local os = require "os"
local table = require "table"
local string = require "string"
local naughty = require "naughty"
local ipairs = ipairs
local beautiful = require("beautiful")

module("wicd")


local menu = nil
local terminal = terminal or os.getenv("TERMINAL") or "/usr/bin/urxvt"

connect = function(id)
    awful.util.spawn("wicd-cli -yc --network " .. id)
end

connect_wired = function()
    awful.util.spawn("wicd-cli -zc")
end

scan = function()
    awful.util.spawn("wicd-cli -yS")
end

launch = function()
    awful.util.spawn(terminal .. " -title WICD -e wicd-curses")
end

show = function()
    local networks = {
        { "WIRED", nil },
        { "  default", connect_wired},
        { "WIRELESS", scan }
    }

    local out = io.popen("wicd-cli -yl|tail -n+2 | cut -f4-")

    local i = 0
    for line in out:lines() do
        table.insert(networks, {"  " .. line, connect(i) })
        i = i + 1
    end
    out:close()

    if #networks == 3 then
        table.insert(networks, {"  (none)", nil})
    end

    menu = awful.menu({items = networks, theme = {bg_normal = beautiful.widgets_menu_bg_normal, bg_focus = beautiful.widgets_menu_bg_focus}})
    menu:show()
end

hide = function()
    menu:hide()
    menu = nil
end

toggle = function()
    if menu == nil then
        show()
    else
        hide()
    end
end

