return {

  -- kanagawa
  {
    "rebelot/kanagawa.nvim",
    opts = {
      background = { dark = "dragon" },
      colors = {
        theme = {
          all = { ui = { bg_gutter = "none" } },
        },
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },

  -- LazyVim (set colorscheme)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
