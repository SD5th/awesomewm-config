local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")



local M = {}


local arc_thickness = 2
local size = 18
local timeout = 2
local notification_position = 'top_right' -- see naughty.notify position argument
local battery_level_cmd = [[upower -b]]

local bg_color = '#ffffff11'
local low_level_color = '#e53935'
local medium_level_color = '#c0ca33'
local high_level_color = '#43a047'
local charging_color = '#3877EC'

local function update_widget(widget, stdout)
  local charge = tonumber(stdout:match("percentage:%s*(%d+)%%") or 0)  
  widget.value = charge
  local isCharging = (stdout:match("state:%s*(%S+)") or "") == "charging"

  if isCharging then
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
      local percent = "N/A"
      local time_empty = nil
      local time_full = nil

      for line in stdout:gmatch("[^\r\n]+") do
        if line:match("percentage:") then
          percent = line:match("percentage:%s*(%d+)%%") or "N/A"
        elseif line:match("time to empty:") then
          local time = line:match("time to empty:%s*(.+)")
          if time and time ~= "0 seconds" and time ~= "0.0 seconds" then
            time_empty = time
          end
        elseif line:match("time to full:") then
          local time = line:match("time to full:%s*(.+)")
          if time and time ~= "0 seconds" and time ~= "0.0 seconds" then
            time_full = time
          end
        end
      end

      local output = "Charge: " .. percent .. "%"
      if time_empty then
        output = output .. "\nDischarging: " .. time_empty
      end
      if time_full then
        output = output .. "\nCharging: " .. time_full
      end

      naughty.destroy(notification)
      notification = naughty.notify {
        text = output,
        title = "Battery",
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