-- Grab environment
local ipairs = ipairs
local awful = require("awful")
local table = table
local capi = {
    screen = screen,
}

-- Eminent: Effortless wmii-style dynamic tagging
local module = {}

-- Grab the original functions we're replacing
local deflayout = nil
local orig = {
    new = awful.tag.new,
    taglist = awful.widget.taglist.new,
    filter = awful.widget.taglist.filter.all,
}

-- Return tags with stuff on them, mark others hidden
function gettags(screen)
    local tags = {}

    for k, t in ipairs(capi.screen[screen]:tags()) do
        if t.selected --[[or #t:clients() > 0]] then
            awful.tag.setproperty(t, "hide", false)
            table.insert(tags, t)
        else
            awful.tag.setproperty(t, "hide", true)
        end
    end

    return tags
end

-- Pre-create tags
awful.tag.new = function (names, screen, layout)
    deflayout = layout and layout[1] or layout
    return orig.new(names, screen, layout)
end

-- Taglist label functions
awful.widget.taglist.filter.all = function (t, args)
    if t.selected --[[or #t:clients() > 0]] then
        return orig.filter(t, args)
    end
end
