local M = {}

local zen_text_width = 80
local backdrop_win = nil
local zen_has_border = function() return vim.o.winborder ~= "" and vim.o.winborder ~= "none" end

local create_backdrop = function()
  local zen_backdrop_config = function()
    return {
      relative = "editor",
      height = math.max(1, vim.o.lines - vim.o.cmdheight),
      width = vim.o.columns,
      row = 0,
      col = 0,
      border = zen_has_border() and vim.o.winborder or "none",
      style = "minimal",
      zindex = 50,
      title = zen_has_border() and " Zen " or nil,
    }
  end

  local backdrop_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[backdrop_buf].bufhidden = "wipe"
  vim.bo[backdrop_buf].swapfile = false

  backdrop_win = vim.api.nvim_open_win(backdrop_buf, false, zen_backdrop_config())
  vim.wo[backdrop_win].fillchars = "eob: "
  vim.wo[backdrop_win].winhighlight = "Normal:NormalFloat,EndOfBuffer:NormalFloat"
  vim.wo[backdrop_win].winblend = 0
end

M.zen = function()
  local zen_content_config = function()
    local border_width = zen_has_border() and 2 or 0
    local max_width = math.max(1, vim.o.columns - border_width)
    local width = math.min(zen_text_width + MiniMisc.get_gutter_width(), max_width)
    local config = {
      border = zen_has_border() and { "", "—", "", "", "", "—", "", "" } or "none",
      col = math.max(0, math.floor((vim.o.columns - width - border_width) / 2)),
      width = width,
      zindex = 51,
      title = "",
    }
    return config
  end
  if backdrop_win then
    vim.api.nvim_win_close(backdrop_win, true)
    backdrop_win = nil
  else
    create_backdrop()
  end

  MiniMisc.zoom(0, zen_content_config())
end

return M
