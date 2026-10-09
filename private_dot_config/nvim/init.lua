-- Define config table to be able to pass data between scripts
_G.Config = {}

local gr = vim.api.nvim_create_augroup("custom-config", {})

--- Create an autocommand in the custom-config augroup
--- Also simplifies opts via direct arguments
---@param event string Event that triggers the autocommand
---@param pattern string | nil Pattern to match against the event
---@param callback function Callback function to call on autocommand
---@param desc string Description of the autocommand
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

--- Define custom `vim.pack.add()` hook helper via an autocommand that runs on PackChanged
--- Plugin data is passed as argument to the callback. See `:h vim.pack-events` ().
--- Must be used before `vim.pack.add()` for the relevant plugin.
--- Example usage: `Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")`
---@param plugin_name string Name of the plugin
---@param kinds string[] Kinds of events ("install", "update", "delete")
---@param callback function Callback function executed on event
---@param desc string Description of the autocmd
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev.data)
  end
  Config.new_autocmd("PackChanged", "*", f, desc)
end

-- Load mini.nvim now to have mini.misc available for helpers below
-- See plugin/30_mini.lua for more
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Loading helpers used to organize config into fail-safe parts. Example usage:
-- - `now` - execute immediately. Use for what must be executed during startup.
--   Like colorscheme, statusline, tabline, dashboard, etc.
-- - `later` - execute a bit later. Use for things not needed during startup.
-- - `now_if_args` - use only if needed during startup when Neovim is started
--   like `nvim -- path/to/file`, but otherwise delaying is fine.
-- - Others are better used only if the above is not enough for good performance.
--   Use only if you are comfortable with adding complexity to your config:
--   - `on_event` - execute once on a first matched event. Like "delay until
--     first Insert mode enter": `on_event('InsertEnter', function() ... end)`.
--   - `on_filetype` - execute once on a first matched filetype. Like "delay
--     until first Lua file": `on_filetype('lua', function() ... end)`.
--
-- See also:
-- - `:h MiniMisc.safely()`
-- - 'plugin/30_mini.lua' and 'plugin/40_plugins.lua'
local misc = require("mini.misc")
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely("filetype:" .. ft, f) end
