local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local pactl = require("modules.screen.my-widgets.audio-control.pactl")
local config = require("modules.screen.my-widgets.audio-control.config")

local M = {}

function M.new_widget()
  local refresh_rate = config.widget_refresh_rate
  local step = config.volume_step
  local ICON_DIR = config.icon_dir
  local device = '@DEFAULT_SINK@'

  local widget = wibox.widget {
    {
      id = "icon",
      resize = false,
      widget = wibox.widget.imagebox,
    },
    valign = 'center',
    layout = wibox.container.place,
  }

  function widget:update_icon()
    local muted = pactl.get_mute(device)

    local volume_icon_name
    if muted then
      volume_icon_name = "muted"
    else
      local volume = pactl.get_volume(device)
      if volume <= 0 then
        volume_icon_name = "muted"
      elseif volume <= 33 then
        volume_icon_name = "low"
      elseif volume <= 66 then
        volume_icon_name = "medium"
      elseif volume <= 100 then
        volume_icon_name = "high"
      else 
        volume_icon_name = "extreme"
      end

    end
    self:get_children_by_id('icon')[1]:set_image(ICON_DIR .. "" .. volume_icon_name .. '.svg')
  end


  widget.volume = {}

  function widget.volume:inc(s)
    pactl.volume_increase(device, s or step)
    widget:update_icon()
  end

  function widget.volume:dec(s)
    pactl.volume_decrease(device, s or step)
    widget:update_icon()
  end

  function widget.volume:toggle()
    pactl.mute_toggle(device)
    widget:update_icon()
  end


  widget.popup = require("modules.screen.my-widgets.audio-control.popup").new_popup()

  function widget.volume:popup()
    widget.popup:toggle_visible()
  end


  widget:buttons(
    awful.util.table.join(
      awful.button({}, 1, function() widget.volume:toggle() end),
      awful.button({}, 3, function() widget.volume:popup() end),
      awful.button({}, 4, function() widget.volume:inc() end),
      awful.button({}, 5, function() widget.volume:dec() end)
    )
  )

  gears.timer {
    timeout   = refresh_rate,
    call_now  = true,
    autostart = true,
    callback  = function()
      widget:update_icon()
    end
  }

  return widget
end

return M