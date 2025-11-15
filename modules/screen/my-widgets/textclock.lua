local wibox = require("wibox")


local M = {}

function M.new()
  return wibox.widget.textclock("%a %d %b | %H:%M")
end

return M