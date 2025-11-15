local awful = require("awful")

local M = {}

-- Each screen has its own tag table.
	local tag_names = { "1", "2", "3", "4", "5" }
	local als = awful.layout.suit
	awful.layout.layouts = {
		als.tile,
		als.max,
		-- als.floating,
		-- als.tile.left,
		-- als.tile.bottom,
		-- als.tile.top,
		-- als.fair,
		-- als.fair.horizontal,
		-- als.spiral,
		-- als.spiral.dwindle,
		-- als.max.fullscreen,
		-- als.magnifier,
		-- als.corner.nw,
		-- als.corner.ne,
		-- als.corner.sw,
		-- als.corner.se,
	}

function M.set(s)
  awful.tag(tag_names, s, awful.layout.layouts[1])
end	

return M