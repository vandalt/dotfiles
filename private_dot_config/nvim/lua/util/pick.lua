M = {}

-- Function to pick chezmoi files with mini.pick
---@param targets? string|string[]
M.pick_chezmoi = function(targets)
  local results = require("chezmoi.commands").list({
    ---@diagnostic disable-next-line: assign-type-mismatch
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

return M
