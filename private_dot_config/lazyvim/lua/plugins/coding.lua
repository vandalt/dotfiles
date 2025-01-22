return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "default" },
    },
  },
  { "echasnovski/mini.pairs", enabled = false },
  {
    "roobert/f-string-toggle.nvim",
    dev = true,
    -- stylua: ignore
    keys = {
      { "<leader>fs", function() require("f-string-toggle").toggle_fstring() end, desc = "Toggle f-string" },
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
    "danymat/neogen",
    opts = {
      snippet_engine = "nvim",
      languages = { python = { template = { annotation_convention = "reST" } } },
    },
    keys = {
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
