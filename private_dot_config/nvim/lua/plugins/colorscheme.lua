return {
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
      -- load the colorscheme here
      -- vim.cmd([[colorscheme kanagawa]])
    end,
  }
}
