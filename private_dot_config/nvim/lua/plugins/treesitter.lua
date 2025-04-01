return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Call setup on this module
    lazy = false,
    keys = {
      { "<C-Space>", desc = "Increment Selection" },
      { "<C-BS>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      ensure_installed = {
        "astro",
        "bibtex",
        "c",
        "css",
        "html",
        "go",
        "gomod",
        "gowork",
        "gosum",
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
        "typescript",
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
          init_selection = "<C-Space>", -- set to `false` to disable one of the mappings
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<C-BS>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            -- Custom code cells defined for jupyter in after/queries/markdown/textobjects.scm
            -- the default block was in conflict with indents etc.
            ["aj"] = "@code_cell.outer",
            ["ij"] = "@code_cell.inner",
            ["ah"] = "@section.outer",
          },
          -- Could replace with function but would not save that much space and would complicate
          selection_modes = {
            ["@function.outer"] = "V",
            ["@function.inner"] = "V",
            ["@class.outer"] = "V",
            ["@class.inner"] = "V",
            ["@block.outer"] = "V",
            ["@block.inner"] = "V",
            ["@conditional.outer"] = "V",
            ["@conditional.inner"] = "V",
            ["@loop.outer"] = "V",
            ["@loop.inner"] = "V",
            ["@section.outer"] = "V",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]j"] = { query = { "@code_cell.inner", "@cell.comment" }, desc = "Goto next cell" },
          },
          goto_next_end = { ["]M"] = "@function.outer", ["]C"] = "@class.outer", ["]J"] = "@code_cell.outer" },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[j"] = { query = { "@code_cell.inner", "@cell.comment" }, desc = "Goto prev cell" },
          },
          goto_previous_end = { ["[M"] = "@function.outer", ["[C"] = "@class.outer", ["[J"] = "@code_cell.outer" },
        },
      },
    },
  },
}
