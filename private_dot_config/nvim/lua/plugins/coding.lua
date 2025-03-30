return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {},
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          ---@diagnostic disable-next-line: param-type-mismatch
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "nvim",
      languages = { python = { template = { annotation_convention = "reST" } } },
    },
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Annotations (Neogen)",
      },
      {
        "<leader>cp",
        function()
          require("neogen").generate({ annotation_convention = { python = "numpydoc" } })
        end,
        desc = "Generate Numpydoc Annotations (Neogen)",
      },
      {
        "<leader>cg",
        function()
          require("neogen").generate({ annotation_convention = { python = "google_docstrings" } })
        end,
        desc = "Generate Google Annotations (Neogen)",
      },
    },
  },
  {
    "Wansmer/treesj",
    -- stylua: ignore
    keys = {
      { "<leader>ts", function() require("treesj").toggle() end, desc = "Toggle split/join for code block" },
    },
    opts = {
      use_default_keymaps = false,
      langs = {
        python = {
          -- Split/join Python functions when cursor on name or "def"
          function_definition = {
            target_nodes = { "parameters" },
          },
        },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
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
    keys = {
      { "<leader>cv", "<Cmd>VenvSelect<CR>", desc = "Select virtual envionment" },
    },
  },
  {
    "roobert/f-string-toggle.nvim",
    dev = false,
    opts = {
      key_binding = "<leader>fs",
      key_binding_desc = "Toggle f-string",
      filetypes = { "python", "snakemake", "markdown", "org" },
    },
  },
}
