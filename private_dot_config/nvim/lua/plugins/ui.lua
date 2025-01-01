return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { section_separators = "", component_separators = "" },
      sections = {
        lualine_y = { "encoding", "fileformat" },
        lualine_z = {
          { "progress", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    enabled = true,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
]],
        },
      },
      styles = {
        terminal = {
          keys = {
            term_normal = false,
          },
        },
      },
    },
  },
}
