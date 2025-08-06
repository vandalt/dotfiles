return {
  "tpope/vim-sleuth", -- Indent, keeping for md and qmd notebooks mostly
  "tpope/vim-eunuch", -- Shell commands
  "justinmk/vim-gtfo", -- Exit vim, keeping for gof, not using got
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- before all other start plugins
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true, -- Load main colorscheme during startup...
    event = "VeryLazy", -- Enables completion for alternative colorschemes
    -- priority = 1000, -- before all other start plugins
    opts = {
      transparent = false,
      overrides = function(colors)
        return {
          ["@string.special.url"] = { fg = colors.theme.syn.special1, underline = true, undercurl = false },
        }
      end,
      background = {
        dark = "wave",
        light = "lotus",
      }
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
    end,
  }
}
