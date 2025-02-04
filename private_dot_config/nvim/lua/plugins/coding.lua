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
      { "<leader>ts", function() require("treesj").split() end, desc = "Split code block" },
      { "<leader>tj", function() require("treesj").join() end, desc = "Join code block" },
      { "<leader>tt", function() require("treesj").toggle() end, desc = "Toggle split/join for code block" },
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
      anaconda_base_path = os.getenv("HOME") .. "./miniforge3",
      anaconda_envs_path = os.getenv("HOME") .. "./miniforge3/envs",
    },
    keys = {
      { "<leader>cv", "<Cmd>VenvSelect<CR>", desc = "Select virtual envionment" },
    },
  },
  {
    "roobert/f-string-toggle.nvim",
    config = function()
      require("f-string-toggle").setup({
        key_binding = "<leader>tf",
        key_binding_desc = "Toggle f-string"
      })
    end,
  },
}
