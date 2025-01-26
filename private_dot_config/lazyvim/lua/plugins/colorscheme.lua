return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      on_colors = function(colors)
        -- Make line numbers a bit brighter
        colors.fg_gutter = colors.comment
      end,
      styles = {
        -- These can be dark, transparent or normal
        sidebars = "dark",
        floats = "normal",
      },
    },
  },
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
