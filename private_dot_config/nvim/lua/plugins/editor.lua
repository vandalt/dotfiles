return {

  -- mini.splitjoin
  {
    "nvim-mini/mini.splitjoin",
    opts = {},
  },

  -- oil.nvim
  -- TODO: Figure out why the git status does not work
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
}
