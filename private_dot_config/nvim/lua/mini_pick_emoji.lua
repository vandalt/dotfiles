local M = {}

local emoji_url = "https://raw.githubusercontent.com/muan/unicode-emoji-json/refs/heads/main/data-by-emoji.json"
local cache_file = vim.fn.stdpath("cache") .. "/mini-pick/emoji-v1.json"

local notify = function(message, level) vim.notify(message, level, { title = "Emoji picker" }) end

local normalize = function(data)
  local items = {}
  for emoji, info in pairs(data) do
    if type(emoji) == "string" and type(info) == "table" and type(info.name) == "string" then
      local group = type(info.group) == "string" and info.group or ""
      table.insert(items, {
        emoji = emoji,
        group = group,
        name = info.name,
        text = string.format("%s  %s  %s", emoji, info.name, group),
      })
    end
  end
  table.sort(items, function(a, b) return a.name < b.name end)
  return items
end

local decode_items = function(encoded)
  local ok, decoded = pcall(vim.json.decode, encoded)
  if not ok or not vim.islist(decoded) then
    return nil
  end

  for _, item in ipairs(decoded) do
    if
      type(item) ~= "table"
      or type(item.emoji) ~= "string"
      or type(item.group) ~= "string"
      or type(item.name) ~= "string"
      or type(item.text) ~= "string"
    then
      return nil
    end
  end
  return decoded
end

local read_cache = function()
  if vim.fn.filereadable(cache_file) == 0 then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, cache_file)
  local items = ok and decode_items(table.concat(lines, "\n")) or nil
  if items then
    return items
  end

  notify("Could not read cached emoji data; downloading a fresh copy.", vim.log.levels.WARN)
  return nil
end

local write_cache = function(items)
  vim.fn.mkdir(vim.fn.fnamemodify(cache_file, ":h"), "p")
  local ok, result = pcall(vim.fn.writefile, { vim.json.encode(items) }, cache_file)
  if ok and result == 0 then
    return true
  end

  notify("Could not write emoji cache: " .. cache_file, vim.log.levels.ERROR)
  return false
end

local load_items = function()
  local cached_items = read_cache()
  if cached_items then
    return cached_items
  end

  if vim.fn.executable("curl") == 0 then
    notify("curl is required to download emoji data.", vim.log.levels.ERROR)
    return nil
  end

  local output = vim.fn.system({ "curl", "-fsSL", emoji_url })
  if vim.v.shell_error ~= 0 then
    notify("Could not download emoji data: " .. vim.trim(output), vim.log.levels.ERROR)
    return nil
  end

  local ok, data = pcall(vim.json.decode, output)
  if not ok or type(data) ~= "table" then
    notify("Downloaded emoji data is not valid JSON.", vim.log.levels.ERROR)
    return nil
  end

  local items = normalize(data)
  if #items == 0 then
    notify("Downloaded emoji data contains no usable emojis.", vim.log.levels.ERROR)
    return nil
  end

  if not write_cache(items) then
    return nil
  end
  return items
end

local insert_emoji = function(item, mode)
  local target = MiniPick.get_picker_state().windows.target
  if not vim.api.nvim_win_is_valid(target) then
    notify("Original window is no longer available.", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_win_get_buf(target)
  if not vim.bo[buf].modifiable then
    notify("Target buffer is not modifiable.", vim.log.levels.ERROR)
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(target)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
  local insert_col = mode == "n" and col + (line == "" and 0 or 1) or col
  vim.api.nvim_buf_set_text(buf, row - 1, insert_col, row - 1, insert_col, { item.emoji })

  local cursor_col = mode == "n" and insert_col or insert_col + #item.emoji
  vim.api.nvim_win_set_cursor(target, { row, cursor_col })
end

M.pick = function()
  local mode = vim.api.nvim_get_mode().mode
  local items = load_items()
  if not items then
    return
  end

  MiniPick.start({
    source = {
      choose = function(item) insert_emoji(item, mode) end,
      items = items,
      name = "Emoji",
    },
  })
end

return M
