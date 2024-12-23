return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = false, -- Will be transparent only if match terminal theme
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
  {
    "LazyVim/LazyVim",
    opts = {
      -- Catppuccin and Tokyonight installed with LazyVim
      colorscheme = "tokyonight",
    },
  },
}
