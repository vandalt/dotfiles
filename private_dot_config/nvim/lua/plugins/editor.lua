return {

  -- oil.nvim
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

  -- snacks explorer
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        replace_netrw = false,
      },
    },
  },

  -- which-key
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

  -- trouble.nvim (snacks picker)
  {
    "folke/trouble.nvim",
    optional = true,
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
  },
}
