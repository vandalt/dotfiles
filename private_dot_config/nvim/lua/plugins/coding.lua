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
}
