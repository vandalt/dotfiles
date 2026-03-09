M = {}


M.map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Functions taken from MiniMax to load plugins early or later
M.now = function(f) require("mini.misc").safely("now", f) end
M.later = function(f) require("mini.misc").safely("later", f) end

-- Plugin hook to execute after install or update of a plugin
---@param plugin_name string Name of the plugin
---@param kinds table<string> Event kinds ("update" or "install") on which to run the hook
---@param callback function Function ran by the hook for autocmd, should have no arguments
---@param desc string Short description of the hook for autocmd
M.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback()
  end
  vim.api.nvim_create_autocmd("PackChanged", { callback = f, desc = desc })
end

return M
