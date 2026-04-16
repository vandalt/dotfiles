return {

  -- conform.nvim
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.fish = {}
      return opts
    end,
  },

  -- blink.cmp
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { auto_show = false },
        ghost_text = { enabled = false },
      },
    },
  },

  -- mini.ai
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      local myopts = {
        custom_textobjects = {
          j = require("util").combined_cell_spec,
        },
      }
      return vim.tbl_deep_extend("force", opts, myopts)
    end,
  },

  -- snakemake
  {
    "snakemake/snakemake",
    ft = "snakemake",
    config = function(plugin) vim.opt.rtp:append(plugin.dir .. "/misc/vim") end,
    init = function(plugin) require("lazy.core.loader").ftdetect(plugin.dir .. "/misc/vim") end,
  },
}
