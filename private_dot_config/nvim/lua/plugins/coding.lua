return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "default" },
    }
  },
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "nvim",
      languages = {
        python = {
          template = {
            -- NOTE: With reST type hints act as type docstrings.
            -- i.e. no type docstring lines. This is expected behaviour.
            annotation_convention = "reST",
          },
        },
      },
    },
    keys = {
      {
        "<leader>nn",
        function()
          require("neogen").generate({})
        end,
        desc = "Generate annotation with Neogen",
      },
      {
        "<leader>np",
        function()
          require("neogen").generate({ annotation_convention = { python = "numpydoc" } })
        end,
        desc = "Generate Numpydoc annotation with Neogen",
      },
      {
        "<leader>ng",
        function()
          require("neogen").generate({ annotation_convention = { python = "google_docstrings" } })
        end,
        desc = "Generate Google docstrings annotation with Neogen",
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    opts = {
      mappings = {
        -- Auto add 2nd space in parentheses (not square bc TODO in markdown)
        [" "] = { action = "open", pair = "  ", neigh_pattern = "[%({][%)}]" },

        -- Don't add pair when followed by alphanumeric
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%w]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%w]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%w]" },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\][^%w]" },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\][^%w]" },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\][^%w]" },

        -- Don't autocomplete quotes around letters, except f-strings
        ['"'] = {
          action = "closeopen",
          pair = '""',
          neigh_pattern = '[^A-Za-eg-z0-9\\"][^%w]',
          register = { cr = false },
        },
        ["'"] = {
          action = "closeopen",
          pair = "''",
          neigh_pattern = "[^A-Za-eg-zçÇ0-9\\'][^%w]",
          register = { cr = false },
        },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%a\\`/][^%w]", register = { cr = false } },
      },
    },
  },
  {
    "roobert/f-string-toggle.nvim",
    dev = true,
    keys = {
      { "<leader>fs", function() require("f-string-toggle").toggle_fstring() end, desc = "Toggle f-string" },
    },
  },
  {
    "Wansmer/treesj",
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
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
            target_nodes = { 'parameters' },
          },
        }
      }

    },
  },
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    keys = {
      { "<leader>cpp", "<cmd>Copilot enable<CR>", desc = "Enable Copilot" },
      { "<leader>cpd", "<cmd>Copilot disable<CR>", desc = "Disable Copilot" },
    },
  },
}
