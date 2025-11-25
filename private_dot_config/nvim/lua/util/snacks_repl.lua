local M = {}

-- Extract text from buffer given start/end positions and mode
local function extract_text(start_pos, end_pos, full_lines)
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  if start_line == 0 or end_line == 0 then
    return {}
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if not full_lines then
    -- Handle single line selection with column ranges
    if #lines == 1 then
      local start_col = start_pos[3]
      local end_col = end_pos[3]
      lines[1] = string.sub(lines[1], start_col, end_col)
    elseif #lines > 1 then
      -- Trim first and last lines to selection columns
      lines[1] = string.sub(lines[1], start_pos[3])
      lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end
  end

  return lines
end

-- Get visual selection (works even if still in visual mode)
local function get_visual_selection()
  local mode = vim.fn.mode()
  local is_visual = mode:match("[vV\22]")

  -- Determine if we're in line-wise visual mode (V) or character/block mode (v, ^V)
  local full_lines = false
  if is_visual then
    full_lines = mode == "V"
  else
    full_lines = vim.fn.visualmode() == "V"
  end

  local start_pos, end_pos
  if is_visual then
    -- Still in visual mode, use current cursor and visual start
    start_pos = vim.fn.getpos("v")
    end_pos = vim.fn.getpos(".")
    -- Ensure start comes before end
    if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
      start_pos, end_pos = end_pos, start_pos
    end
  else
    -- Left visual mode, use marks
    start_pos = vim.fn.getpos("'<")
    end_pos = vim.fn.getpos("'>")
  end

  return extract_text(start_pos, end_pos, full_lines)
end

-- Get text from motion (for use with operatorfunc)
local function get_motion_selection()
  local start_pos = vim.fn.getpos("'[")
  local end_pos = vim.fn.getpos("']")

  -- Determine if line-wise based on motion type
  local motion_type = vim.fn.visualmode()
  local full_lines = motion_type == "V"

  return extract_text(start_pos, end_pos, full_lines)
end

M.send_lines = function(text_type, opts)
  opts = opts or {}

  -- Get terminal using count (default to 1)
  local count = opts.count or vim.v.count1
  local term = Snacks.terminal.get(nil, { count = count, create = false })
  if not term then
    vim.notify("No terminal found for count " .. count, vim.log.levels.ERROR)
    return
  end
  local job_id = vim.b[term.buf].terminal_job_id

  -- Get the text
  local text
  if text_type == nil or text_type == "line" then
    text = vim.api.nvim_get_current_line()
  elseif text_type == "visual" then
    local lines = get_visual_selection()
    text = table.concat(lines, "\n")
    -- Exit visual mode if still in it
    if vim.fn.mode():match("[vV\22]") then
      vim.cmd("normal! \27") -- \27 is <Esc>
    end
    -- Add extra newline for multi-line visual selections in IPython
    if #lines > 1 then
      text = text .. "\n"
    end
  else
    local lines = get_motion_selection()
    text = table.concat(lines, "\n")
  end

  local start_seq = opts.bracketed and "\x1b[200~" or ""
  local end_seq = opts.bracketed and "\x1b[201~" or ""

  vim.fn.chansend(job_id, start_seq .. text .. end_seq .. "\n")
end

---@diagnostic disable-next-line: unused-local
M.send_lines_motion = function() M.send_lines("motion", { bracketed = true, count = vim.g.snacks_repl_count }) end

M.send_motion_operator = function()
  vim.g.snacks_repl_count = vim.v.count1
  vim.go.operatorfunc = "v:lua.require'util.snacks_repl'.send_lines_motion"
  return "g@"
end

return M
