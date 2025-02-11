return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- Load main colorscheme during startup...
    priority = 1000, -- before all other start plugins
    opts = {
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
