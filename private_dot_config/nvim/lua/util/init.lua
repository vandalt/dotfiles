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
--- @param start_week_day string
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
    vim.notify("python")
    return require("notebook-navigator").miniai_spec(ai_type)
  else
    return require("mini.ai").gen_spec.treesitter({ a = "@cell.outer", i = "@cell.inner" })(ai_type, id, opts)
  end
end

-- Function to pick chezmoi files with mini.pick
---@param targets string|string[]
M.pick_chezmoi = function(targets)
  local results = require("chezmoi.commands").list({
    targets = targets,
    args = {
      "--include",
      "files",
      "--exclude",
      "externals",
    },
  })

  local function choose_fn(item)
    local source_path = require("chezmoi.commands").source_path({
      targets = { item },
    })[1]
    require("mini.pick").default_choose(source_path)
  end
  require("mini.pick").start({
    source = {
      items = results,
      name = "Chezmoi",
      cwd = vim.fn.expand("~"),
      choose = choose_fn,
      show = function(buf_id, items, query) return MiniPick.default_show(buf_id, items, query, { show_icons = true }) end,
    },
  })
end

-- Yank the path of the current file to any register
---@param register string
M.yank_path = function(register)
  register = register or "@"
  local file_path = vim.fn.expand("%:~")
  vim.fn.setreg(register, file_path)
  vim.notify("Yanked file " .. file_path .. " to register '" .. register .. "'")
end

-- Git status picker with mini.pick
M.pick_git_status = function()
  local _split_status_path = function(status) return string.match(status, "^%s*(%S+)%s+(%S+)$") end
  -- Convert str items to table with text and path fields.
  -- That way the path is used to get file icons, but the full status is shown
  local show_fn = function(buf_id, items, query)
    for i, item in ipairs(items) do
      local _, path = _split_status_path(item)
      items[i] = { text = item, path = path }
    end
    return MiniPick.default_show(buf_id, items, query, { show_icons = true })
  end
  -- Extract the file path from the status str, otherwise `default_choose` will not open it
  local choose_fn = function(item)
    local _, path = _split_status_path(item)
    return MiniPick.default_choose(path)
  end
  local local_opts = { command = { "git", "status", "-s" } }
  local source = {
    name = "Git status",
    show = show_fn,
    choose = choose_fn,
  }
  return MiniPick.builtin.cli(local_opts, { source = source })
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

-- Disable snacks.image. First finds all existing autocmds from snacks.image,
-- then removes them and saves them to a global variable to re-enable later
M.disable_snacks_image = function()
  -- Some group names depend on image ID so we find them based on their events
  local events = {
    "BufWinEnter",
    "WinEnter",
    "BufWinLeave",
    "BufEnter",
    "WinClosed",
    "WinNew",
    "WinResized",
    "BufWritePost",
    "WinScrolled",
    "ModeChanged",
    "CursorMoved",
    "BufWipeout",
    "BufDelete",
    "BufWriteCmd",
    "FileType",
    "BufReadCmd",
  }
  local all_autocmds = vim.api.nvim_get_autocmds({event = events })
  local image_autocmds = {}
  local group_set = {}
  for _, autocmd in ipairs(all_autocmds) do
    if autocmd.group_name ~= nil and string.find(autocmd.group_name, "snacks.image", 1, true) then
      image_autocmds[#image_autocmds + 1] = autocmd
      group_set[autocmd.group_name] = true
    end
  end
  -- Save autocmds and augroups for when it is time to re-enable
  _G.image_autocmds = image_autocmds
  _G.image_augroups = group_set
  -- Clean buffer and clear augroups
  Snacks.image.placement.clean()
  for group, _ in pairs(group_set) do
    vim.api.nvim_create_augroup(group, {clear = true})
  end
  -- For toggle
  _G.snacks_disabled = true
end

-- Re-enable snacks.image after it was disabled
-- The function re-creates all autocmds and then re-attaches all buffers that were attached
M.enable_snacks_image = function()
  -- Re-create the groups
  for group, _ in pairs(image_augroups) do
    vim.api.nvim_create_augroup(group, { clear = true })
  end
  -- Re-create autocmds. Some keys need to be cleared or modified
  -- so that format from get_autocmds works with create_autocmd
  for _, autocmd in ipairs(image_autocmds) do
    autocmd.group = autocmd.group_name
    if autocmd.command == "" then autocmd.command = nil end
    autocmd.group_name = nil
    local event = autocmd.event
    autocmd.event = nil
    autocmd.id = nil
    if autocmd.buflocal then
      autocmd.pattern = nil
    end
    autocmd.buflocal = nil
    vim.api.nvim_create_autocmd(event, autocmd)
  end
  -- Loop over buffers and enable those with compatible filetype
  local bufs = vim.api.nvim_list_bufs()
  local langs = Snacks.image.langs()
  for _, buf in ipairs(bufs) do
    local ft = vim.bo[buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if vim.tbl_contains(langs, lang) then
      -- Make sure the buffer is detached otherwise attach does nothing
      vim.b[buf].snacks_image_attached = false
      Snacks.image.doc.attach(buf)
    end
  end
  _G.snacks_disabled = false
end

M.toggle_snacks_image = function()
  if snacks_disabled == nil then _G.snacks_disabled = false end
  if snacks_disabled then
    M.enable_snacks_image()
  else
    M.disable_snacks_image()
  end
end

return M
