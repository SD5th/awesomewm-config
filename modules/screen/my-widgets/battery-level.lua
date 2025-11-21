local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")



local M = {}


local arc_thickness = 2
local size = 18
local timeout = 2
local notification_position = 'top_right' -- see naughty.notify position argument
local battery_level_cmd = [[bash -c 'acpi | grep -v unavailable']]

local bg_color = '#ffffff11'
local low_level_color = '#e53935'
local medium_level_color = '#c0ca33'
local high_level_color = '#43a047'
local charging_color = '#3877EC'

local function update_widget(widget, stdout)
  local charge = tonumber(0)
  local is_charging

  for s in stdout:gmatch("[^\r\n]+") do
    local cur_status, charge_str, _ = string.match(s, '.+: ([%a%s]+), (%d?%d?%d)%%,?(.*)')
    if cur_status ~= nil and charge_str ~=nil then
      local cur_charge = tonumber(charge_str)
      if cur_charge > charge then
        is_charging = cur_status == 'Charging'
        charge = cur_charge
      end
    end
  end

  widget.value = charge

  if is_charging or charge == 100 then
    widget.background.bg = charging_color
  elseif charge < 15 then
    widget.background.bg = low_level_color
  elseif charge < 40 then
    widget.background.bg = medium_level_color
  else
    widget.background.bg = high_level_color
  end
end

local function create_widget()
  local widget_background = wibox.container.background(wibox.widget{widget = wibox.widget.textbox})

  local batteryarc_widget = wibox.widget {
    widget_background,
    max_value = 100,
    rounded_edge = true,
    thickness = arc_thickness,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = size,
    forced_width = size,
    bg = bg_color,
    paddings = 2,
    widget = wibox.container.arcchart
  }

  batteryarc_widget.background = widget_background

  return batteryarc_widget
end

local notification
local function show_battery_status()
  awful.spawn.easy_async(battery_level_cmd,
    function(stdout, _, _, _)
      naughty.destroy(notification)
      notification = naughty.notify {
        text = stdout,
        title = "Battery status",
        timeout = 10,
        width = 200,
        position = notification_position,
      }
    end
  )
end


function M.new()
  local battery_level_widget = create_widget()

  battery_level_widget:connect_signal("mouse::enter", function() show_battery_status() end)
  battery_level_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

  watch(battery_level_cmd, timeout, update_widget, battery_level_widget)

  return battery_level_widget
end

return M