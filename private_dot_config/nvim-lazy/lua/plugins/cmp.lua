return {
  {
    "saghen/blink.cmp",
    enabled = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    dev = false,

    -- use a release tag to download pre-built binaries or use cargo
    -- Cargo requires rust nightly. rustup provides it.
    -- See: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- version = "1.*",
    build = "cargo build --release",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      cmdline = { enabled = false },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = false, auto_insert = false } },
        menu = {
          auto_show = true,
        },
        documentation = { auto_show = false },
      },
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
