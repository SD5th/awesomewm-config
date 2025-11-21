-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Core AwesomeWM functionality
require("awful.autofocus")
require("beautiful").init("/home/sultan/.config/awesome/theme.lua")

-- Configuration modules (order matters!)
require("modules.error-handling-init") 
require("modules.rules.init")          
require("modules.bindings.init")       
require("modules.screen.init")         
require("modules.signals-init")        

-- Final initialization
require("modules.autostart")
--require("modules.auto-lock-init")