return {

  -- vim-gtfo
  { "justinmk/vim-gtfo" },

  -- vim-arsync
  {
    "kenn7/vim-arsync",
    dependencies = { "prabirshrestha/async.vim" },
    keys = {
      { "<leader>ru", "<Cmd>ARsyncUp<CR>", desc = "Rsync up to remote" },
      { "<leader>rd", "<Cmd>ARsyncDown<CR>", desc = "Rsync down from remote" },
    },
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = { prompt_for_file_name = false, drag_and_drop = { enabled = false } },
    },
    keys = {
      { "<leader>p", "<Cmd>PasteImage<CR>", desc = "Paste image from system clipboard" },
    },
  },

  -- mini.splitjoin
  {
    "nvim-mini/mini.splitjoin",
    opts = {},
    keys = { { "gS" } },
  },

  -- oil.nvim
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      win_options = {
        signcolumn = "yes:2", -- required for status
      },
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-a>"] = { "actions.select", opts = { horizontal = true } },
      },
    },
    keys = {
      { "-", "<Cmd>Oil<CR>", desc = "Open oil.nvim" },
    },
  },

  -- oil.git-status.nvim
  -- requires an autocmd to work with Snacks.statuscolumn, see autocmds.lua
  {
    "refractalize/oil-git-status.nvim",
    ft = "oil",
    dependencies = {
      "stevearc/oil.nvim",
    },
    opts = {},
  },

  -- which-key.nvim
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>r", group = "+run/rsync", icon = { icon = "", hl = "" } },
          { "<leader>z", group = "+zk", icon = { icon = "󰠮", hl = "" } },
          { "<leader>j", desc = "+jupyter", icon = { icon = "", hl = "" } },
        },
      },
    },
  },
}
