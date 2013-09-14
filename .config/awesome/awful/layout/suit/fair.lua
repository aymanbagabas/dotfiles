---------------------------------------------------------------------------
-- @author Josh Komoroske
-- @copyright 2012 Josh Komoroske
-- @release v3.5.1-7-ga0e45e8
---------------------------------------------------------------------------

-- Grab environment we need
local ipairs = ipairs
local math = math
local beautiful = require("beautiful")

--- Fair layouts module for awful
-- awful.layout.suit.fair
local fair = {}

local function do_fair(p, orientation)
    local wa = p.workarea
    local cls = p.clients

    -- Swap workarea dimensions, if our orientation is "east"
    if orientation == 'east' then
        wa.width, wa.height = wa.height, wa.width
        wa.x, wa.y = wa.y, wa.x
    end

    if #cls > 0 then
        local rows, cols = 0, 0
        if #cls == 2 then
            rows, cols = 1, 2
        else
            rows = math.ceil(math.sqrt(#cls))
            cols = math.ceil(#cls / rows)
        end

        for k, c in ipairs(cls) do
            k = k - 1
            local g = {}

            local row, col = 0, 0
            row = k % rows
            col = math.floor(k / rows)

            local lrows, lcols = 0, 0
            if k >= rows * cols - rows then
                lrows = #cls - (rows * cols - rows)
                lcols = cols
            else
                lrows = rows
                lcols = cols
            end

            if row == lrows - 1 then
                g.height = wa.height - math.ceil(wa.height / lrows) * row
                g.y = wa.height - g.height
            else
                g.height = math.ceil(wa.height / lrows)
                g.y = g.height * row
            end

            if col == lcols - 1 then
                g.width = wa.width - math.ceil(wa.width / lcols) * col
                g.x = wa.width - g.width
            else
                g.width = math.ceil(wa.width / lcols)
                g.x = g.width * col
            end

            g.height = g.height - c.border_width * 2
            g.width = g.width - c.border_width * 2
            g.y = g.y + wa.y
            g.x = g.x + wa.x

            -- Swap window dimensions, if our orientation is "east"
            if orientation == 'east' then
                g.width, g.height = g.height, g.width
                g.x, g.y = g.y, g.x
            end
            -- Useless gap.
            useless_gap = beautiful.useless_gap_width or 25
            if useless_gap > 0
            then
                -- Top and left clients are shrinked by two steps and
                -- get moved away from the border. Other clients just
                -- get shrinked in one direction.

                top = false
		left = false

                if g.x == wa.x then
                    top = true
                end

		if g.y == wa.y then
		    left = true
		end

		if top then
	                g.width = g.width - 2 * useless_gap
        	        g.x = g.x + useless_gap
		else
			g.width = g.width - useless_gap
		end

		if left then
                	g.height = g.height - 2 * useless_gap
                	g.y = g.y + useless_gap
		else
			g.height = g.height - useless_gap
		end
            end
            -- End of useless gap.

            c:geometry(g)
        end
    end
end

--- Horizontal fair layout.
-- @param screen The screen to arrange.
fair.horizontal = {}
fair.horizontal.name = "fairh"
function fair.horizontal.arrange(p)
    return do_fair(p, "east")
end

-- Vertical fair layout.
-- @param screen The screen to arrange.
fair.name = "fairv"
function fair.arrange(p)
    return do_fair(p, "south")
end

return fair
