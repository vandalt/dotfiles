return {

  -- snacks.nvim
  {
    "folke/snacks.nvim",
    opts = {},
  },

  -- chezmoi.nvim
  {
    "xvzc/chezmoi.nvim",
    opts = {},
    keys = {
      {
        "<leader>fc",
        function()
          require("chezmoi.pick")[LazyVim.pick.picker.name](vim.fn.stdpath("config"))
        end,
        desc = "nvim config files (chezmoi)",
      },
      {
        "<leader>fz",
        function()
          require("chezmoi.pick")[LazyVim.pick.picker.name]()
        end,
        desc = "chezmoi config files",
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      local chezmoi_entry = {
        icon = " ",
        key = "c",
        desc = "Config",
        action = function()
          require("chezmoi.pick")[LazyVim.pick.picker.name](vim.fn.stdpath("config"))
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
      table.insert(opts.dashboard.preset.keys, config_index, chezmoi_entry)
    end,
  },
}
