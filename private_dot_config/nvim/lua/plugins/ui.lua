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
    -- Does not play nice with quarto-nvim's rename functionality
    "stevearc/dressing.nvim",
    enabled = false,
  },
  -- {
  --   "dressing.nvim",
  --   opts = {
  --     select = {
  --       enabled = false,
  --     }
  --   }
  -- },
  {
    "folke/zen-mode.nvim",
    dependencies = {
      -- Zen-mode will auto-activate twilight if installed
      "folke/twilight.nvim"
    }
  },
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end
  }
}
