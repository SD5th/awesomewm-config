local awful = require("awful")

awful.rules.rules = {
	-- All clients will match this rule.
  require("modules.rules.base-clients"),
	-- Floating clients.
  require("modules.rules.floating-clients"),
	-- Add titlebars to normal clients and dialogs
  require("modules.rules.titlebars"),
	-- Set Firefox to always map on the tag named "2" on screen 1.
  table.unpack(require("modules.rules.tag-assignments"))
}
