M = {}

-- Get arguments for debugging
-- Copied from lazyvim since I wanted file completion
---@param config {type?:string, args?:string[]|fun():string[]?}
M.get_args = function(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    -- copilot did this bit
    local co = coroutine.running()
    vim.ui.input({
      prompt = "Run with args: ",
      default = args_str,
      completion = "file",
    }, function(input)
      coroutine.resume(co, input)
    end)
    local new_args = coroutine.yield() --[[@as string]]
    if not new_args then
      return nil
    end
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return vim.fn.expand(new_args)
    end
    return require("dap.utils").splitstr(vim.fn.expand(new_args))
  end
  return config
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

return M
