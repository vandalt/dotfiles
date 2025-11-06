M = {}

-- Pick chezmoi files
-- Copy of the lazyvim function with additional targets options
-- TODO: Can this be made available through LazyVim directly?
---@param targets string|string[]?
M.pick_chezmoi = function(targets)
  local results = require("chezmoi.commands").list({
    ---@diagnostic disable-next-line: assign-type-mismatch
    targets = targets,
    args = {
      "--path-style",
      "absolute",
      "--include",
      "files",
      "--exclude",
      "externals",
    },
  })
  local items = {}

  for _, czFile in ipairs(results) do
    table.insert(items, {
      text = czFile,
      file = czFile,
    })
  end

  ---@type snacks.picker.Config
  local opts = {
    items = items,
    confirm = function(picker, item)
      picker:close()
      require("chezmoi.commands").edit({
        targets = { item.text },
        args = { "--watch" },
      })
    end,
  }
  Snacks.picker.pick(opts)
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
  local all_autocmds = vim.api.nvim_get_autocmds({ event = events })
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
    vim.api.nvim_create_augroup(group, { clear = true })
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
    if autocmd.command == "" then
      autocmd.command = nil
    end
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

-- TODO: Annotations for return?
-- Toggle Snacks.image depending on its current state
---@param enabled boolean Current state of Snacks.image
M.toggle_snacks_image = function(enabled)
  if not enabled then
    M.enable_snacks_image()
    return true
  else
    M.disable_snacks_image()
    return false
  end
end

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

return M
