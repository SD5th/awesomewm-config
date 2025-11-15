local awful = require("awful")


local M = {}

function M.new ()
  return awful.widget.keyboardlayout()
end

return M