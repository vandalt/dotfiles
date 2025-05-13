return {
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy", -- Enables completion for alternative colorschemes
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- Load main colorscheme during startup...
    priority = 1000, -- before all other start plugins
    opts = {
      transparent = true,
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
      -- load the colorscheme here
      vim.cmd([[colorscheme kanagawa]])
    end,
  }
}
