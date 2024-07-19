return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night",
    transparent = false, -- Will be transparent only if match terminal theme
    styles = {
      -- These can be dark, transparent or normal
      sidebars = "dark",
      floats = "normal",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- Catppuccin and Tokyonight installed with LazyVim
      colorscheme = "tokyonight",
    }
  }
}
