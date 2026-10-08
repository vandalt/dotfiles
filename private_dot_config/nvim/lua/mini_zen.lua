local M = {}

local zen_text_width = 80
local zen = { backdrop_win = nil, content_win = nil, augroup = nil }
local zen_has_border = function() return vim.o.winborder ~= "" and vim.o.winborder ~= "none" end

--- Return the configuration for the backdrop window
---
--- Uses a function to dynamically determine the need for borders
---
---@return ... Table with config for vim.api.nvim_open_win()
local zen_backdrop_config = function()
  return {
    col = 0,
    height = math.max(1, vim.o.lines - vim.o.cmdheight),
    border = zen_has_border() and vim.o.winborder or "none",
    relative = "editor",
    row = 0,
    style = "minimal",
    width = vim.o.columns,
    zindex = 50,
    title = zen_has_border() and " Zen " or nil,
  }
end

--- Return the configuration for the Zen window content
---
--- Uses a function to dynamically determine the need for borders
---
---@return ... Table with config for vim.api.nvim_open_win()
local zen_content_config = function()
  local border_width = zen_has_border() and 2 or 0
  local max_width = math.max(1, vim.o.columns - border_width)
  local width = math.min(zen_text_width + MiniMisc.get_gutter_width(zen.content_win), max_width)
  local config = {
    border = zen_has_border() and { "", "—", "", "", "", "—", "", "" } or "none",
    col = math.max(0, math.floor((vim.o.columns - width - border_width) / 2)),
    height = math.max(1, vim.o.lines - vim.o.cmdheight - border_width),
    relative = "editor",
    row = 0,
    width = width,
    zindex = 51,
  }
  return config
end

local is_zen_active = function()
  return zen.backdrop_win
    and zen.content_win
    and vim.api.nvim_win_is_valid(zen.backdrop_win)
    and vim.api.nvim_win_is_valid(zen.content_win)
end

local close_zen = function()
  if zen.augroup then
    vim.api.nvim_del_augroup_by_id(zen.augroup)
  end

  local wins = { zen.content_win, zen.backdrop_win }
  zen = { backdrop_win = nil, content_win = nil, augroup = nil }
  for _, win in ipairs(wins) do
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
end

--- Update zen by completely closing if inactive of updating the config if active
local update_zen = function()
  if not is_zen_active() then
    close_zen()
    return
  end

  vim.api.nvim_win_set_config(zen.backdrop_win, zen_backdrop_config())
  vim.api.nvim_win_set_config(zen.content_win, zen_content_config())
end

--- Toggle zoom with MiniMisc.zoom() while accounting for zen
M.toggle_zoom = function()
  if is_zen_active() then
    close_zen()
    return
  end

  MiniMisc.zoom()
end

M.toggle_zen = function()
  if is_zen_active() then
    close_zen()
    return
  end

  close_zen()
  if MiniMisc.zoom() then
    MiniMisc.zoom()
  end

  local backdrop_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[backdrop_buf].bufhidden = "wipe"
  vim.bo[backdrop_buf].swapfile = false

  zen.backdrop_win = vim.api.nvim_open_win(backdrop_buf, false, zen_backdrop_config())
  vim.wo[zen.backdrop_win].fillchars = "eob: "
  vim.wo[zen.backdrop_win].winhighlight = "Normal:NormalFloat,EndOfBuffer:NormalFloat"
  vim.wo[zen.backdrop_win].winblend = 0
  zen.content_win = vim.api.nvim_open_win(0, true, zen_content_config())

  zen.augroup = vim.api.nvim_create_augroup("custom-zen-mode", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", { group = zen.augroup, callback = update_zen })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = zen.augroup,
    pattern = { "cmdheight", "winborder" },
    callback = update_zen,
  })
end

return M
