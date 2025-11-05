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
        }
      }
    }
  },

  -- Snacks (ui opts)
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
      },
    },
  },

  -- Snacks (image toggle)
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      Snacks.toggle({
        name = "Snacks.image",
        get = function()
          return not _G.snacks_disabled
        end,
        set = function(state)
          require("util").toggle_snacks_image(not state)
        end,
      }):map("<leader>uM")
      return opts
    end,
  },

  -- Snacks (dashboard)
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard.preset.header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
      local chezmoi_nvim_entry = {
        icon = " ",
        key = "c",
        desc = "Config",
        action = function()
          require("util").pick_chezmoi(vim.fn.stdpath("config"))
        end,
      }
      local config_index
      for i = #opts.dashboard.preset.keys, 1, -1 do
        if opts.dashboard.preset.keys[i].key == "c" then
          table.remove(opts.dashboard.preset.keys, i)
          config_index = i
          break
        end
      end
      table.insert(opts.dashboard.preset.keys, config_index, chezmoi_nvim_entry)
    end,
  },
}
