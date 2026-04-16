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
}
