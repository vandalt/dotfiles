return {

  -- blink.cmp Completion
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        providers = {
          path = {
            opts = {
              get_cwd = function(_) return vim.fn.getcwd() end,
            },
          },
        },
      },
      cmdline = { enabled = false },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        ---@diagnostic disable-next-line: unused-local
        menu = { auto_show = function(ctx, items) return vim.bo.filetype ~= "markdown" end },
      },
      keymap = { preset = "default" },
    },
  },

  -- mini.snippets
  {
    "nvim-mini/mini.snippets",
    opts = function(_, opts)
      -- override opts.snippets provided by extra to properly include markdown snippets
      local snippets = require("mini.snippets")
      opts.snippets = {
        snippets.gen_loader.from_lang({ lang_patterns = { markdown_inline = { "markdown.json" } } }), -- this is the default in the extra...
      }
    end,
  },

  -- mini.splitjoin
  {
    "nvim-mini/mini.splitjoin",
    opts = {},
  },

  -- Neogen
  {
    "danymat/neogen",
    opts = {
      languages = { python = { template = { annotation_convention = "reST" } } },
    },
    keys = {
      {
        "<leader>cp",
        function() require("neogen").generate({ annotation_convention = { python = "numpydoc" } }) end,
        desc = "Generate Numpy-style Docstrings (Neogen)",
      },
      {
        "<leader>cg",
        function() require("neogen").generate({ annotation_convention = { python = "google_docstrings" } }) end,
        desc = "Generate Google-style Docstrings (Neogen)",
      },
    },
  },

  -- DAP debugging
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>da",
        function() require("dap").continue({ before = require("util").get_args }) end,
        desc = "Run with Args",
      },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    },
  },

  -- venv-selector.nvim
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      settings = {
        search = {
          miniconda_envs = {
            command = "$FD 'bin/python$' ~/miniforge3/envs --full-path --color never",
            type = "anaconda",
          },
          miniconda_base = {
            command = "$FD '/python$' ~/miniforge3/bin --full-path --color never",
            type = "anaconda",
          },
        },
      },
    },
  },

  -- f-string-toggle.nvim
  {
    "roobert/f-string-toggle.nvim",
    opts = {
      key_binding = false,
      filetypes = { "python", "markdown" },
    },
    keys = {
      { "<leader>fs", function() require("f-string-toggle").toggle_fstring() end, desc = "Toggle f-string" },
    },
  },

  -- sidekick.nvim
  {
    "folke/sidekick.nvim",
    opts = {
      nes = {
        enabled = false, -- Start disabled, toggle with uN
      },
    },
    keys = {
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
      {
        "<leader>ai",
        function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
        desc = "Sidekick Toggle Copilot",
      },
    },
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false }, -- toggleable with <leader>uh
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              -- disableTaggedHints = true,
              analysis = {
                -- Disable warnings that ruff already provides
                diagnosticSeverityOverrides = {
                  reportUnusedVariable = "none",
                  reportUnusedImport = "none",
                },
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },

  -- Snakemake highlighting
  {
    "snakemake/snakemake",
    ft = "snakemake",
    config = function(plugin) vim.opt.rtp:append(plugin.dir .. "/misc/vim") end,
    init = function(plugin) require("lazy.core.loader").ftdetect(plugin.dir .. "/misc/vim") end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        snakemake = { "snakefmt" },
      }
    },
  }
}
