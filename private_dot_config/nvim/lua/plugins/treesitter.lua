return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    opts = {
      parsers = {
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
    },
    config = function(_, opts)
      require("nvim-treesitter").install(opts.parsers)
      local filetype_seen = {}
      local all_filetypes = {}
      for _, parser in ipairs(opts.parsers) do
        local parser_fts = vim.treesitter.language.get_filetypes(parser)
        for _, ft in ipairs(parser_fts) do
          if not filetype_seen[ft] then
            all_filetypes[#all_filetypes+1] = ft
            filetype_seen[ft] = true
          end
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = all_filetypes,
        callback = function()
          -- TODO: Disable highlighting for latex
          vim.treesitter.start()
          -- TODO: Sort out this vs what I have in options.lua
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end,
      })
    end,
  },
  -- "nvim-treesitter/nvim-treesitter-textobjects",
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   build = ":TSUpdate",
  --   -- main = "nvim-treesitter.configs", -- Call setup on this module
  --   -- TODO: Switch to main when more stable
  --   branch = "main",
  --   lazy = false,
  --   opts = {
  --     indent = { enable = true },
  --     -- textobjects = {
  --     --   select = {
  --     --     enable = true,
  --     --     lookahead = true,
  --     --     keymaps = {
  --     --       ["af"] = "@function.outer",
  --     --       ["if"] = "@function.inner",
  --     --       ["ac"] = "@class.outer",
  --     --       ["ic"] = "@class.inner",
  --     --       ["ab"] = "@block.outer",
  --     --       ["ib"] = "@block.inner",
  --     --       -- Custom code cells defined for jupyter in after/queries/markdown/textobjects.scm
  --     --       -- the default block was in conflict with indents etc.
  --     --       ["aj"] = "@code_cell.outer",
  --     --       ["ij"] = "@code_cell.inner",
  --     --       ["ah"] = "@section.outer",
  --     --     },
  --     --     -- Could replace with function but would not save that much space and would complicate
  --     --     selection_modes = {
  --     --       ["@function.outer"] = "V",
  --     --       ["@function.inner"] = "V",
  --     --       ["@class.outer"] = "V",
  --     --       ["@class.inner"] = "V",
  --     --       ["@block.outer"] = "V",
  --     --       ["@block.inner"] = "V",
  --     --       ["@conditional.outer"] = "V",
  --     --       ["@conditional.inner"] = "V",
  --     --       ["@loop.outer"] = "V",
  --     --       ["@loop.inner"] = "V",
  --     --       ["@section.outer"] = "V",
  --     --     },
  --     --     include_surrounding_whitespace = false,
  --     --   },
  --     --   move = {
  --     --     enable = true,
  --     --     set_jumps = true,
  --     --     goto_next_start = {
  --     --       ["]m"] = "@function.outer",
  --     --       ["]c"] = "@class.outer",
  --     --       ["]j"] = { query = { "@code_cell.inner", "@cell.comment" }, desc = "Goto next cell" },
  --     --     },
  --     --     goto_next_end = { ["]M"] = "@function.outer", ["]C"] = "@class.outer", ["]J"] = "@code_cell.outer" },
  --     --     goto_previous_start = {
  --     --       ["[m"] = "@function.outer",
  --     --       ["[c"] = "@class.outer",
  --     --       ["[j"] = { query = { "@code_cell.inner", "@cell.comment" }, desc = "Goto prev cell" },
  --     --     },
  --     --     goto_previous_end = { ["[M"] = "@function.outer", ["[C"] = "@class.outer", ["[J"] = "@code_cell.outer" },
  --     --   },
  --     -- },
  --   },
  -- },
}
