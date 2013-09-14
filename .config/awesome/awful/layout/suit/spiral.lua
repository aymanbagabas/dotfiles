---------------------------------------------------------------------------
-- @author Uli Schlachter &lt;psychon@znc.in&gt;
-- @copyright 2009 Uli Schlachter
-- @copyright 2008 Julien Danjou
-- @release v3.5.1-7-ga0e45e8
---------------------------------------------------------------------------

-- Grab environment we need
local ipairs = ipairs
local beautiful = require("beautiful")

-- awful.layout.suit.spiral
local spiral = {}

local function do_spiral(p, _spiral)
    local wa = p.workarea
    local cls = p.clients
    local n = #cls
    
    local static_wa = wa

    for k, c in ipairs(cls) do
        if k < n then
            if k % 2 == 0 then
                wa.height = wa.height / 2
            else
                wa.width = wa.width / 2
            end
        end

        if k % 4 == 0 and _spiral then
            wa.x = wa.x - wa.width
        elseif k % 2 == 0 or
            (k % 4 == 3 and k < n and _spiral) then
            wa.x = wa.x + wa.width
        end

        if k % 4 == 1 and k ~= 1 and _spiral then
            wa.y = wa.y - wa.height
        elseif k % 2 == 1 and k ~= 1 or
            (k % 4 == 0 and k < n and _spiral) then
            wa.y = wa.y + wa.height
        end

        local g = {
            x = wa.x,
            y = wa.y,
            width = wa.width - 2 * c.border_width,
            height = wa.height - 2 * c.border_width
        }
            -- Useless gap.
            useless_gap = beautiful.useless_gap_width or 25
            if useless_gap > 0
            then
                -- Top and left clients are shrinked by two steps and
                -- get moved away from the border. Other clients just
                -- get shrinked in one direction.

                top = false
		left = false

                if g.y == static_wa.y then
                    top = true
                end

		if g.x == static_wa.x then
		    left = true
		end

		if top then
	                g.height = g.height - 2 * useless_gap
        	        g.y = g.y + useless_gap
		else
			g.height = g.height - useless_gap
		end

		if left then
                	g.width = g.width - 2 * useless_gap
                	g.x = g.x + useless_gap
		else
			g.width = g.width - useless_gap
		end
            end
            -- End of useless gap.

        c:geometry(g)
    end
end

--- Dwindle layout
spiral.dwindle = {}
spiral.dwindle.name = "dwindle"
function spiral.dwindle.arrange(p)
    return do_spiral(p, false)
end

--- Spiral layout
spiral.name = "spiral"
function spiral.arrange(p)
    return do_spiral(p, true)
end

return spiral

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
