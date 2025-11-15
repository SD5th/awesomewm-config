local awful = require("awful")


local M = {}

function M.new (s)
  return awful.wibar({
    position = "top",
    screen = s
  })
end

return M