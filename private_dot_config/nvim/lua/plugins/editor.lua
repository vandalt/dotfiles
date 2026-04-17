return {

  -- mini.splitjoin
  {
    "nvim-mini/mini.splitjoin",
    opts = {},
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
    dependencies = {
      "stevearc/oil.nvim",
    },
    opts = {},
  },
}
