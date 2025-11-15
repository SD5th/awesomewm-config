local awful = require("awful")

local M = {}

local systemcontrolsmenu = {
	{
		"Power Off",
		function()
			awful.spawn("shutdown now")
		end,
	},
	{
		"Reboot",
		function()
			awful.spawn("reboot")
		end,
	},
	{
		"Suspend",
		function()
			awful.spawn("systemctl suspend")
		end,
	},
}

local mymainmenu = awful.menu({
	items = {
		{
      "System",
      systemcontrolsmenu
    },
	},
})

function M.new ()
  return awful.widget.launcher({ 
    image = "/home/sultan/.config/awesome/icons/arch64.png",
    menu = mymainmenu })
end

return M