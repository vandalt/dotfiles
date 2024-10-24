return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.completion.completeopt = "menu,menuone,noinsert,noselect"

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- Lazyvim sets this to automatically accept selected. Very obstrusive
        -- Use <C-y> instead
        ["<CR>"] = cmp.config.disable,
        -- No longer needed with above disabled. Use <C-e> instead
        ["<C-CR>"] = cmp.config.disable,
        -- Lazyvim sets this to accept+replace remainder of line
        ["<S-CR>"] = cmp.config.disable,
      })
    end,
    keys = {
      { "<Tab>", false, mode = { "i", "s" } },
      { "<S-Tab>", false, mode = { "i", "s" } },
      {
        "<C-l>",
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
            return
          end
          return "<C-l>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<C-h>",
        function()
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
            return
          end
          return "<C-h>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
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
    enabled = false,
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
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%a\\`][^%w]", register = { cr = false } },
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
    keys = {
      { "<leader>cpp", "<cmd>Copilot enable<CR>", desc = "Enable Copilot" },
      { "<leader>cpd", "<cmd>Copilot disable<CR>", desc = "Disable Copilot" },
    },
  },
}
