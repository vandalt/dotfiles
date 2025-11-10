return {
  {
    "stevearc/oil.nvim",
    enabled = true,
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-a>"] = { "actions.select", opts = { horizontal = true } },
      },
    },
    keys = {
      { "-", "<Cmd>Oil<CR>", desc = "Open parent directory" },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  },
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        replace_netrw = false,
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>z", group = "zk", icon = "󱓩" },
        },
      },
    },
  },
}
