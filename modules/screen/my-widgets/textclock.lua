local wibox = require("wibox")


local M = {}

function M.new()
  return wibox.widget.textclock("%a %b %d, %H:%M")
end

return M