return {

  -- lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_y = { "encoding", "fileformat", "filetype" },
        lualine_z = {
          { "progress", separator = "", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    },
  },

  -- snacks.nvim
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = vim.g.vandalt_dashboard,
      },
      styles = {
        zen = {
          backdrop = { transparent = false },
        },
      },
    },
  },
}
