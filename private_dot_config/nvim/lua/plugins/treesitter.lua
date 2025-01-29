return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Call setup on this module
    -- TODO: Add folding? https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
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
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "grn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function" },
            ["]c"] = { query = "@class.outer", desc = "Next class" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function" },
            ["]C"] = { query = "@class.outer", desc = "Next class" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function" },
            ["[c"] = { query = "@class.outer", desc = "Previous class" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Previous function" },
            ["[C"] = { query = "@class.outer", desc = "Previous class" },
          },
        },
      },
    },
  },
}
