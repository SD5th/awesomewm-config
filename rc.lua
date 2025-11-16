-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Core AwesomeWM functionality
require("awful.autofocus")

-- Configuration modules (order matters!)
require("modules.variables-init")      -- 1. Global variables and settings
require("modules.error-handling-init") -- 2. Error handling setup
require("modules.rules.init")          -- 3. Window rules (before bindings)
require("modules.bindings.init")       -- 4. Key and mouse bindings
require("modules.screen.init")         -- 5. Screen and UI setup
require("modules.signals-init")        -- 6. Client and system signals

-- Final initialization
require("modules.autostart")           -- 7. Startup applications