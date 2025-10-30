M = {}

-- Create a global 'send_motion' function that sends a motion to toggleterm
-- The motion type should be compatible with operatorfunc and g@
-- This wrapper is used to enable passing arguments to send_lines_to_terminal
--- @param trim_spaces boolean
--- @param cmd_data table<string, any>
--- @param use_bracketed_paste boolean?
local function create_send_motion(trim_spaces, cmd_data, use_bracketed_paste)
  _G.send_motion = function(motion_type)
    require("toggleterm").send_lines_to_terminal(motion_type, trim_spaces, cmd_data, use_bracketed_paste)
  end
end

-- To send motions to toggleterm, we need to create a function that can take a motion and set it to operatorfunc
-- The function is then executed with 'g@'
-- Ref: https://github.com/akinsho/toggleterm.nvim/issues/542
--- @param trim_spaces boolean
--- @param cmd_data table<string, any>
--- @param use_bracketed_paste boolean?
M.toggleterm_send_motion = function(trim_spaces, cmd_data, use_bracketed_paste)
  return function()
    -- Create the global "send_motion" function so it can be set
    -- Using a wrapper function to enable passing options
    create_send_motion(trim_spaces, cmd_data, use_bracketed_paste)
    vim.go.operatorfunc = "v:lua.send_motion"
    return "g@"
  end
end

-- Get the start date for zk weekly note
--- @param start_week_day? string
M.get_date_zw = function(start_week_day)
  start_week_day = start_week_day or "sunday"
  ---@diagnostic disable-next-line: param-type-mismatch
  if string.lower(os.date("%A")) == start_week_day then
    return "today"
  else
    return start_week_day
  end
end

-- mini.ai spec that handles python files and markdown notebooks
-- notebook-navigator is used for the former and treesitter for the latter
---@param ai_type string
---@param id string
---@param opts table<string,any>
M.combined_cell_spec = function(ai_type, id, opts)
  if vim.bo.filetype == "python" then
    return require("notebook-navigator").miniai_spec(ai_type)
  else
    return require("mini.ai").gen_spec.treesitter({ a = "@cell.outer", i = "@cell.inner" })(ai_type, id, opts)
  end
end

-- Yank the path of the current file to any register
---@param register? string
M.yank_path = function(register)
  register = register or "@"
  local file_path = vim.fn.expand("%:~")
  vim.fn.setreg(register, file_path)
  vim.notify("Yanked path " .. file_path .. " to register '" .. register .. "'")
end

-- Function used as callback for better git blame
-- Ref: https://github.com/nvim-mini/mini.nvim/discussions/2029
---@param au_data table<string,any>
M.git_blame_autocmd = function(au_data)
  if au_data.data.git_subcommand ~= "blame" then
    return
  end

  local win_src = au_data.data.win_source
  local buf = au_data.buf
  local win = au_data.data.win_stdout

  -- Opts
  vim.bo[buf].modifiable = false
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true
  -- View
  vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
  vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
  vim.wo[win].scrollbind, vim.wo[win_src].scrollbind = true, true
  vim.wo[win].cursorbind, vim.wo[win_src].cursorbind = true, true
  -- Vert width
  if au_data.data.cmd_input.mods:match("vertical") then
    local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
    local width = vim.iter(lines):fold(-1, function(acc, ln)
      local stat = string.match(ln, "^%S+ %b()")
      return math.max(acc, vim.fn.strwidth(stat))
    end)
    width = width + vim.fn.getwininfo(win)[1].textoff
    vim.api.nvim_win_set_width(win, width)
  end

  -- Highlight
  vim.fn.matchadd("GitBlameHashRoot", [[^^\w\+]])
  vim.fn.matchadd("GitBlameHash", [[^\w\+]])
  local leftmost = [[^.\{-}\zs]]
  vim.fn.matchadd("GitBlameAuthor", leftmost .. [[(\zs.\{-} \ze\d\{4}-]])
  vim.fn.matchadd("GitBlameDate", leftmost .. [[[0-9-]\{10} [0-9:]\{8} [+-]\d\+]])
end

M.minipick_select_idx = function(items, opts, on_choice)
  opts = opts or {}
  local format_item = opts.format_item or tostring
  opts.format_item = function(item)
    local idx = vim.tbl_contains(items, item) and vim.fn.index(items, item) + 1 or "?"
    return string.format("[%d] %s", idx, format_item(item))
  end
  return MiniPick.ui_select(items, opts, on_choice)
end

return M
