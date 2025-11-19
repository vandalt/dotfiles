return {
  {
    "xvzc/chezmoi.nvim",
    dev = false,
    keys = {
      { "<leader>sz", false },
      { "<leader>sZ", false },
      { "<leader>fz", function() require("chezmoi.pick").snacks() end, desc = "Chezmoi" },
      {
        "<leader>fc",
        function() require("chezmoi.pick").snacks(vim.fn.stdpath("config")) end,
        desc = "Chezmoi nvim files",
      },
    },
  },

  -- Snacks dashboard chezmoi entry
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      local chezmoi_nvim_entry = {
        icon = " ",
        key = "c",
        desc = "Config",
        action = function() require("chezmoi.pick").snacks(vim.fn.stdpath("config")) end,
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
