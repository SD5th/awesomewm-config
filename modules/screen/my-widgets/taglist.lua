local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")


local M = {}

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

function M.new (s)
  return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		--style = {
		--	shape_border_width = 1,
		--	shape_border_color = "#777777",
		--	shape = gears.shape.rounded_bar,
		--},
		layout = {
			spacing = 0,
			layout = wibox.layout.flex.horizontal,
		},
	})
end

return M