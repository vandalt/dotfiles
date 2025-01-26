return {
  -- TODO: Add parsers
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Call setup on this module
    opts = {
      ensure_installed = {
        "bibtex",
        "c",
        "latex",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "ninja",
        "python",
        "query",
        "rst",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "latex" },
      },
      indent = { enable = true },
      -- TODO: Add folding? https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "grn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
  },
}
