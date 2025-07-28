local function snacks_picker_chezmoi(targets)
  -- Ref: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/util/chezmoi.lua
  local results = require("chezmoi.commands").list({
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
return {
  {
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
    end
  },
  {
    "xvzc/chezmoi.nvim",
    cmd = "ChezmoiEdit",
    dev = false,
    opts = {},
    keys = {
      {
        "<leader>fz",
        function()
          snacks_picker_chezmoi()
        end,
        desc = "Find chezmoi files",
      },
      {
        "<leader>fc",
        function()
          snacks_picker_chezmoi(vim.fn.stdpath("config"))
        end,
        desc = "Find nvim config files (chezmoi)",
      },
    },
    init = function()
      -- Automatically apply files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function(ev)
          local bufnr = ev.buf
          local edit_watch = function()
            require("chezmoi.commands.__edit").watch(bufnr)
          end
          vim.schedule(edit_watch)
        end,
      })
    end
  },
}
