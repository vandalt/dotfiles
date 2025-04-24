return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = function()
      local cmp = require("cmp")
      return {
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        -- TODO: Remove when done testing zk
        -- completion = {
        --   autocomplete = false,
        -- },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}), -- trigger completion
        }),
        sources = {
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
          { name = "copilot", group_index = 2 },
          { name = "snippets" },
          { name = "path" },
          { name = "buffer" },
        },
      }
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries or use cargo
    version = "1.*",
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
