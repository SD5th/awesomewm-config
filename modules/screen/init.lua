local awful = require("awful")
local wibox = require("wibox")


local menubar = require("menubar")
local terminal = require("config").terminal
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

local mylauncher = require("modules.screen.my-widgets.launcher").new()

local mykeyboardlayout = require("modules.screen.my-widgets.keyboardlayout").new()

local mytextclock = require("modules.screen.my-widgets.textclock").new()

local battery_level_widget = require("modules.screen.my-widgets.battery-level").new()

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
  require("modules.screen.wallpaper").set(s)

  -- Tags
  require("modules.screen.tags").set(s)

	-- Create a taglist widget
	s.mytaglist = require("modules.screen.my-widgets.taglist").new(s)

	-- Create a tasklist widget
	s.mytasklist = require("modules.screen.my-widgets.tasklist").new(s)

	-- Create the wibox
	s.mywibox = require("modules.screen.my-widgets.wibox").new(s)

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,

		{ -- Left widgets
			mylauncher,
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 3,
			
			wibox.widget.systray(),
			mykeyboardlayout,
			mytextclock,
			battery_level_widget
		},
	})
end)