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
    dev = true,
    opts = {},
    keys = {
      {
        "<leader>fz",
        function()
          require("telescope").extensions.chezmoi.find_files()
        end,
        desc = "Find chezmoi files",
      },
      {
        "<leader>fc",
        function()
          require("telescope").extensions.chezmoi.find_files({targets = vim.fn.stdpath("config")})
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
