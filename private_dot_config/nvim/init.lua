-- Create a global Config table for small custom utils
_G.Config = {}

-- Install mini.nvim early
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Functions taken from MiniMax to load plugins early or later
local misc = require("mini.misc")
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end

-- Plugin hook
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  vim.api.nvim_create_autocmd("PackChanged", {callback  = f, desc = desc})
end
