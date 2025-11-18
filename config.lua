local M = {}

M.terminal = "alacritty"
M.editor = os.getenv("EDITOR") or "nvim"
M.locker_cmd = "dm-tool lock"


M.modkey = "Mod4"

return M