---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Julien Danjou
-- @release v3.5
---------------------------------------------------------------------------

-- Grab environment we need
local capi = { screen = screen,
               image = image,
               client = client }
local ipairs = ipairs
local setmetatable = setmetatable
local table = table
local common = require("awful.widget.common")
local beautiful = require("beautiful")
local client = require("awful.client")
local util = require("awful.util")
local tag = require("awful.tag")
local flex = require("wibox.layout.flex")

--- Tasklist widget module for awful
module("awful.widget.tasklist")

-- awful.widget.tasklist
local tasklist = { mt = {} }

-- Public structures
tasklist.filter = {}

local function tasklist_label(c, args)

    if not args then args = {} end
    local theme = beautiful.get()
    local fg_normal = args.fg_normal or theme.tasklist_fg_normal or theme.fg_normal
    local bg_normal = args.bg_normal or theme.tasklist_bg_normal or theme.bg_normal
    local fg_focus = args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus
    local bg_focus = args.bg_focus or theme.tasklist_bg_focus or theme.bg_focus
    local fg_urgent = args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent
    local bg_urgent = args.bg_urgent or theme.tasklist_bg_urgent or theme.bg_urgent
    local fg_minimize = args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize
    local bg_minimize = args.bg_minimize or theme.tasklist_bg_minimize or theme.bg_minimize
    local font = args.font or theme.tasklist_font or theme.font or ""
    local bg = nil
    local text = "<span font_desc='"..font.."'>"
    local name = ""

    -- symbol to use to indicate certain client properties
    local sticky = args.sticky or theme.tasklist_sticky or '[S] ' --"▪"
    local ontop = args.ontop or theme.tasklist_ontop or '[T] ' --'⌃'
    local floating = args.floating or theme.tasklist_floating or '[F] ' -- '✈'
    local maximized_horizontal = args.maximized_horizontal or theme.tasklist_maximized_horizontal or '[M] ' --  '⬌'
   local maximized_vertical = args.maximized_vertical or theme.tasklist_maximized_vertical or '' -- '⬍'

    if c.sticky then name = name .. sticky end
    if c.ontop then name = name .. ontop end
    if client.floating.get(c) then name = name .. floating end
    if c.maximized_horizontal then name = name .. maximized_horizontal end
    if c.maximized_vertical then name = name .. maximized_vertical end
    if c.minimized then
        name = name .. (util.escape(c.icon_name) or util.escape(c.name) or util.escape("<untitled>"))
    else
        name = name .. (util.escape(c.name) or util.escape("<untitled>"))
    end
    if capi.client.focus == c then
        bg = bg_focus
        if fg_focus then
            text = text .. "<span color='"..util.color_strip_alpha(fg_focus).."'>"..name.."</span>"
        else
            text = text .. "<span color='"..util.color_strip_alpha(fg_normal).."'>"..name.."</span>"
        end
    elseif c.urgent and fg_urgent then
        bg = bg_urgent
        text = text .. "<span color='"..util.color_strip_alpha(fg_urgent).."'>"..name.."</span>"
    elseif c.minimized and fg_minimize and bg_minimize then
        bg = bg_minimize
        text = text .. "<span color='"..util.color_strip_alpha(fg_minimize).."'>"..name.."</span>"
    else
        bg = bg_normal
        text = text .. "<span color='"..util.color_strip_alpha(fg_normal).."'>"..name.."</span>"
    end
    text = text .. "</span>"
        
    --return text, bg, nil, c.icon
    return text, bg, nil, nil
end

local function tasklist_update(s, w, buttons, filter, data, style)
    local clients = {}
    for k, c in ipairs(capi.client.get()) do
        if not (c.skip_taskbar or c.hidden
            or c.type == "splash" or c.type == "dock" or c.type == "desktop")
            and filter(c, s) then
            table.insert(clients, c)
        end
    end

    local function label(c) return tasklist_label(c, style) end

    common.list_update(w, buttons, label, data, clients)
end

--- Create a new tasklist widget.
-- @param screen The screen to draw tasklist for.
-- @param filter Filter function to define what clients will be listed.
-- @param buttons A table with buttons binding to set.
-- @param style The style overrides default theme.
-- bg_normal The background color for unfocused client.
-- fg_normal The foreground color for unfocused client.
-- bg_focus The background color for focused client.
-- fg_focus The foreground color for focused client.
-- bg_urgent The background color for urgent clients.
-- fg_urgent The foreground color for urgent clients.
-- bg_minimize The background color for minimized clients.
-- fg_minimize The foreground color for minimized clients.
-- floating Symbol to use for floating clients.
-- ontop Symbol to use for ontop clients.
-- maximized_horizontal Symbol to use for clients that have been horizontally maximized.
-- maximized_vertical Symbol to use for clients that have been vertically maximized.
-- font The font.
function tasklist.new(screen, filter, buttons, style)
    local w = flex.horizontal()

    local data = setmetatable({}, { __mode = 'k' })
    local u = function () tasklist_update(screen, w, buttons, filter, data, style) end
    tag.attached_connect_signal(screen, "property::selected", u)
    tag.attached_connect_signal(screen, "property::activated", u)
    capi.client.connect_signal("property::urgent", u)
    capi.client.connect_signal("property::sticky", u)
    capi.client.connect_signal("property::ontop", u)
    capi.client.connect_signal("property::floating", u)
    capi.client.connect_signal("property::maximized_horizontal", u)
    capi.client.connect_signal("property::maximized_vertical", u)
    capi.client.connect_signal("property::minimized", u)
    capi.client.connect_signal("property::name", u)
    capi.client.connect_signal("property::icon_name", u)
    capi.client.connect_signal("property::icon", u)
    capi.client.connect_signal("property::skip_taskbar", u)
    capi.client.connect_signal("property::screen", u)
    capi.client.connect_signal("property::hidden", u)
    capi.client.connect_signal("tagged", u)
    capi.client.connect_signal("untagged", u)
    capi.client.connect_signal("unmanage", u)
    capi.client.connect_signal("list", u)
    capi.client.connect_signal("focus", u)
    capi.client.connect_signal("unfocus", u)
    u()
    return w
end

--- Filtering function to include all clients.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @return true
function tasklist.filter.allscreen(c, screen)
    return true
end

--- Filtering function to include the clients from all tags on the screen.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @return true if c is on screen, false otherwise
function tasklist.filter.alltags(c, screen)
    -- Only print client on the same screen as this widget
    return c.screen == screen
end

--- Filtering function to include only the clients from currently selected tags.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @return true if c is in a selected tag on screen, false otherwise
function tasklist.filter.currenttags(c, screen)
    -- Only print client on the same screen as this widget
    if c.screen ~= screen then return false end
    -- Include sticky client too
    if c.sticky then return true end
    local tags = tag.gettags(screen)
    for k, t in ipairs(tags) do
        if t.selected then
            local ctags = c:tags()
            for _, v in ipairs(ctags) do
                if v == t then
                    return true
                end
            end
        end
    end
    return false
end

--- Filtering function to include only the minimized clients from currently selected tags.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @return true if c is in a selected tag on screen and is minimized, false otherwise
function tasklist.filter.minimizedcurrenttags(c, screen)
    -- Only print client on the same screen as this widget
    if c.screen ~= screen then return false end
    -- Check client is minimized
    if not c.minimized then return false end
    -- Include sticky client
    if c.sticky then return true end
    local tags = tag.gettags(screen)
    for k, t in ipairs(tags) do
        -- Select only minimized clients
        if t.selected then
            local ctags = c:tags()
            for _, v in ipairs(ctags) do
                if v == t then
                    return true
                end
            end
        end
    end
    return false
end

--- Filtering function to include only the currently focused client.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @return true if c is focused on screen, false otherwise
function tasklist.filter.focused(c, screen)
    -- Only print client on the same screen as this widget
    return c.screen == screen and capi.client.focus == c
end

function tasklist.mt:__call(...)
    return tasklist.new(...)
end

return setmetatable(tasklist, tasklist.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
