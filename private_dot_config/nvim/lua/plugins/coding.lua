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

  -- f-string-toggle.nvim
  -- TODO: Make it work with markdown code blocks
  {
    "roobert/f-string-toggle.nvim",
    dev = true,
    opts = {
      key_binding = false,
      filetypes = { "python", "markdown", "snakemake" },
    },
    keys = {
      { "<leader>fs", function() require("f-string-toggle").toggle_fstring() end, desc = "Toggle f-string" },
    },
  },

  -- mini.snippets
  {
    "nvim-mini/mini.snippets",
    opts = function(_, opts)
      opts.snippets = {
        require("mini.snippets").gen_loader.from_lang({
          lang_patterns = { markdown_inline = { "markdown.json" }, snakemake = { "python/*.json", "snakemake.json" } },
        }),
      }
    end,
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

  -- neogen (docstrings)
  {
    "danymat/neogen",
    opts = {
      languages = { python = { template = { annotation_convention = "reST" } } },
    },
    keys = {
      { "<leader>cn", function() require("neogen").generate() end, desc = "Generate docstrings" },
      {
        "<leader>cp",
        function() require("neogen").generate({ annotation_convention = { python = "numpydoc" } }) end,
        desc = "Numpy docstrings",
      },
      {
        "<leader>cg",
        function() require("neogen").generate({ annotation_convention = { python = "google_docstrings" } }) end,
        desc = "Google docstrings",
      },
    },
  },

  -- snakemake
  {
    "snakemake/snakemake",
    ft = "snakemake",
    config = function(plugin) vim.opt.rtp:append(plugin.dir .. "/misc/vim") end,
    init = function(plugin) require("lazy.core.loader").ftdetect(plugin.dir .. "/misc/vim") end,
  },
}
