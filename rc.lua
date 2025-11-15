-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Load modules
require("modules.variables-init")
require("modules.error-handling-init")
require("modules.signals-init")
require("modules.screen.init")
require("modules.bindings.init")
require("modules.rules.init")