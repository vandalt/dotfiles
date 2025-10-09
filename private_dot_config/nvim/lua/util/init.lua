M = {}

-- Create a global 'send_motion' function that sends a motion to toggleterm
-- The motion type should be compatible with operatorfunc and g@
-- This wrapper is used to enable passing argumetns to send_lines_to_terminal
local function create_send_motion(trim_spaces, cmd_data, use_bracketed_paste)
  _G.send_motion = function(motion_type)
    require("toggleterm").send_lines_to_terminal(motion_type, trim_spaces, cmd_data, use_bracketed_paste)
  end
end

-- To send motions to toggleterm, we need to create a function that can take a motion and set it to operatorfunc
-- The function is then executed with 'g@'
-- Ref: https://github.com/akinsho/toggleterm.nvim/issues/542
M.toggleterm_send_motion = function(trim_spaces, cmd_data, use_bracketed_paste)
  return function()
    -- Create the global "send_motion" function so it can be set
    -- Using a wrapper function to enable passing options
    create_send_motion(trim_spaces, cmd_data, use_bracketed_paste)
    vim.go.operatorfunc = "v:lua.send_motion"
    return "g@"
  end
end

M.get_date_zw = function(start_week_day)
  start_week_day = start_week_day or "sunday"
  ---@diagnostic disable-next-line: param-type-mismatch
  if string.lower(os.date("%A")) == start_week_day then
    return "today"
  else
    return start_week_day
  end
end

M.combined_cell_spec = function(ai_type, id, opts)
  if vim.bo.filetype == "python" then
    vim.notify("python")
    return require("notebook-navigator").miniai_spec(ai_type)
  else
    return require("mini.ai").gen_spec.treesitter({ a = "@cell.outer", i = "@cell.inner" })(ai_type, id, opts)
  end
end

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

M.yank_path = function(register)
  register = register or "@"
  local file_path = vim.fn.expand("%:~")
  vim.fn.setreg(register, file_path)
  vim.notify("Yanked file " .. file_path .. " to register '" .. register .. "'")
end

M.pick_git_status = function()
  local show_fn = function(buf_id, items, query)
    -- Convert items to a table and extract path to get file icons
    for i, item in ipairs(items) do
      local _, filepath = string.match(item, "^%s*(%S+)%s+(%S+)$")
      items[i] = { text = item, path = filepath }
    end
    return MiniPick.default_show(buf_id, items, query, { show_icons = true })
  end
  local choose_fn = function(item)
    local _, path = string.match(item, "^%s*(%S+)%s+(%S+)$")
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

return M
