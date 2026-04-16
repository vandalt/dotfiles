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

  -- LazyVim (set colorscheme)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
