return {

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { section_separators = "", component_separators = "|" },
      sections = {
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          { "location", padding = { left = 0, right = 0 } },
        },
      },
    },
  },

  -- Noice
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",  -- "cmdline" for regular, "cmdline_popup" for palette
      }
    },
  },

  -- Snacks (ui opts)
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
      },
      styles = {
        zen = {
          backdrop = { transparent = false, blend = 40 },
        },
      },
    },
  },

  -- Snacks (image toggle)
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      Snacks.toggle({
        name = "Snacks.image",
        get = function() return not _G.snacks_disabled end,
        set = function(state) require("util").toggle_snacks_image(not state) end,
      }):map("<leader>uM")
      return opts
    end,
  },

  -- Snacks dashboard
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard.enabled = false
      opts.dashboard.preset.header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
    end,
  },
}
