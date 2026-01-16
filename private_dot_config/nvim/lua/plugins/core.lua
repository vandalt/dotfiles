return {
  -- vim-gtfo
  "justinmk/vim-gtfo", -- Exit vim, keeping for gof, not using got

   "tpope/vim-eunuch",

  -- lazy.nvim
  { "folke/lazy.nvim", version = false },

  -- kanagawa.nvim
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- before all other start plugins
    opts = {
      transparent = false,
      overrides = function(colors)
        return {
          ["@string.special.url"] = { fg = colors.theme.syn.special1, underline = true, undercurl = false },
        }
      end,
      background = {
        dark = "dragon",
        light = "lotus",
      }
    },
    -- config = function(_, opts)
    --   require("kanagawa").setup(opts)
    --   -- load the colorscheme here
    --   -- vim.cmd([[colorscheme kanagawa]])
    -- end,
  },

  -- LazyVim
  {
    "LazyVim/LazyVim",
    version = false, -- version = "*" for latest release
    opts = {
      colorscheme = "kanagawa",
      -- load the default settings
      defaults = {
        autocmds = true, -- lazyvim.config.autocmds
        keymaps = true, -- lazyvim.config.keymaps
        -- lazyvim.config.options can't be configured here since that's loaded before lazyvim setup
        -- if you want to disable loading options, add `package.loaded["lazyvim.config.options"] = true` to the top of your init.lua
      },
    },
  },
}
