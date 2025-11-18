local awful = require("awful")
local gears = require("gears")

local lock_timer = nil

local locker_cmd = require("config").locker_cmd

local function lock_system()
  awful.spawn(locker_cmd)
  lock_timer = nil
end

local function check_idle_and_activity()
  awful.spawn.easy_async("xprintidle", function(idle_stdout)
    local idle_time_ms = tonumber(idle_stdout) or 0
    local idle_time_sec = idle_time_ms / 1000    

    if idle_time_sec > 600 then
      awful.spawn.easy_async_with_shell("wpctl status | grep active", function(_, _, _, audio_exitcode)
        local audio_playing = (audio_exitcode == 0)
        
        if audio_playing then
          if lock_timer then
            lock_timer:stop()
            lock_timer = nil
          end
        else
          if not lock_timer then
            lock_timer = gears.timer {
              timeout = 20, -- 20 seconds countdown before locking
              autostart = true,
              single_shot = true,
              callback = lock_system
            }
          end
        end
    end)
else

    if lock_timer then
      lock_timer:stop()
      lock_timer = nil
    end
end
    end)
end

gears.timer {
  timeout = 5,
  autostart = true,
  callback = check_idle_and_activity
}