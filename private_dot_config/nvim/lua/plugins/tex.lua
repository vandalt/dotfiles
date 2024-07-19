return {
  {
    "lervag/vimtex",
    config = function()
      -- NOTE: This block is from lazyvim
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"


      -- Use okular
      -- vim.g.vimtex_view_general_viewer = "okular"
      -- vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
      -- Use zathura
      -- vim.g.vimtex_view_method = "zathura_simple" -- simple means don't use xdotool
      -- Use sioyek
      vim.g.vimtex_view_method = "sioyek" -- simple means don't use xdotool
    end,
  }
}
