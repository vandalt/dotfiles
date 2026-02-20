M = {}

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

M.toggle_snacks_image = function(enabled)
  if not enabled then
    M.enable_snacks_image()
    return true
  else
    M.disable_snacks_image()
    return false
  end
end

local toggle_mini = function(module_name)
  local disable_opt = string.gsub(module_name, "%.", "") .. "_disable"
  vim.g[disable_opt] = not vim.g[disable_opt]
  return not vim.g[disable_opt]
end

---@param mystr string
local find_str_type = function(mystr)
  if mystr:match("^mini.*$") then
    return "mini"
  elseif vim.opt[mystr] ~= nil then
    return "opt"
  elseif vim.g[mystr] ~= nil then
    return "var"
  end
end


-- Toggle an option or run a function to toggle something
---@param opt string|function Option to toggle, can be a string from vim.g
---or a function that toggles something. If a function, should return true when
---the option has been enabled and false if it has been disabled. mini.nvim's
---mini*_disable options are recognized and the "Enable/disable" message is flipped.
---@param name string? Name of the option that will be toggled. Used in the notification
M.toggle = function(opt, name)
  -- Some more complicated toggles have custom functions
  -- Has precendence over all other built-in behaviours
  local custom = { ["Snacks.image"] = M.toggle_snacks_image }
  if type(opt) == "string" and custom[opt] ~= nil then
    name = opt
    opt = custom[opt]
  end

  local enabled
  if vim.is_callable(opt) then
    -- Either run the custom function or the one passed by caller
    enabled = opt()
    name = name or ""
  elseif type(opt) == "string" then
    -- for strings, it's either an option or a variable
    name = name or opt
    local str_type = find_str_type(opt)
    if str_type == "mini" then
      enabled = toggle_mini(opt)
    elseif str_type == "opt" then
      vim.opt[opt] = not vim.opt[opt]:get()
      enabled = vim.opt[opt]:get()
    elseif str_type == "var" then
      vim.g[opt] = not vim.g[opt]
      enabled = vim.g[opt]
    end
  end
  local action = enabled and "Enabled" or "Disabled"
  vim.notify(action .. " " .. name)
end

return M
