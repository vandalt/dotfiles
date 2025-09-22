local add = require("mini.deps").add

local ts_branch = "main"

local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = ts_branch,
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end,
  },
})
add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = ts_branch })
local parsers = {
  "diff",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "rst",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}
local filetype_seen = {}
local all_filetypes = {}
for _, parser in ipairs(parsers) do
  local parser_fts = vim.treesitter.language.get_filetypes(parser)
  for _, ft in ipairs(parser_fts) do
    if not filetype_seen[ft] then
      all_filetypes[#all_filetypes + 1] = ft
      filetype_seen[ft] = true
    end
  end
end

if ts_branch == "main" then
  require("nvim-treesitter").install(parsers)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = all_filetypes,
    callback = function()
      vim.treesitter.start()
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  require("nvim-treesitter-textobjects").setup({
    select = { lookahead = false, lookbehind = false, include_surrounding_whitespace = false },
  })

  -- stylua: ignore start
  -- Select
  -- map({"x", "o"}, "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer") end, "around function")
  -- map({"x", "o"}, "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner") end, "inside function")
  -- map({"x", "o"}, "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer") end, "around class")
  -- map({"x", "o"}, "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner") end, "inside class")
  -- map({"x", "o"}, "ab", function() require("nvim-treesitter-textobjects.select").select_textobject("@block.outer") end, "around block")
  -- map({"x", "o"}, "ib", function() require("nvim-treesitter-textobjects.select").select_textobject("@block.inner") end, "inside block")
  -- map({"x", "o"}, "aj", function() require("nvim-treesitter-textobjects.select").select_textobject("@cell.outer") end, "around cell")
  -- map({"x", "o"}, "ij", function() require("nvim-treesitter-textobjects.select").select_textobject("@cell.inner") end, "inside cell")

  -- Move
  map({"n", "x", "o"}, "]m", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer") end, "next method")
  map({"n", "x", "o"}, "]M", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer") end, "next method end")
  map({"n", "x", "o"}, "[m", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer") end, "previous method")
  map({"n", "x", "o"}, "[M", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer") end, "previous method end")
  map({"n", "x", "o"}, "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer") end, "next class")
  map({"n", "x", "o"}, "]C", function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer") end, "next class end")
  map({"n", "x", "o"}, "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer") end, "previous class")
  map({"n", "x", "o"}, "[C", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer") end, "previous class end")
  map({"n", "x", "o"}, "]j", function() require("nvim-treesitter-textobjects.move").goto_next_start({"@cell.outer", "@cell.comment"}) end, "next cell")
  map({"n", "x", "o"}, "[j", function() require("nvim-treesitter-textobjects.move").goto_previous_start({"@cell.outer", "@cell.comment"}) end, "previous cell")
  -- stylua: ignore end
else
  ---@diagnostic disable-next-line:missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = parsers,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "around function" },
          ["if"] = { query = "@function.inner", desc = "inside function" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "inside class" },
          ["ab"] = { query = "@block.outer", desc = "around block" },
          ["ib"] = { query = "@block.inner", desc = "inside block" },
          ["aj"] = { query = "@cell.outer", desc = "around cell" },
          ["ij"] = { query = "@cell.inner", desc = "inside cell" },
        },
        include_surrounding_whitespace = true,
      },
      move = {
        enable = true,
        -- NOTE: Using cell.comment and cell.outer separately so that "aj" mapping in Python is notebooknavigator
        goto_next_start = {
          ["]m"] = { query = "@function.outer", desc = "next method" },
          ["]c"] = { query = "@class.outer", desc = "next class" },
          ["]j"] = { query = { "@cell.outer", "@cell.comment" }, desc = "next cell" },
        },
        goto_next_end = {
          ["]M"] = { query = "@function.outer", desc = "next method end" },
          ["]C"] = { query = "@class.outer", desc = "next class end" },
        },
        goto_previous_start = {
          ["[m"] = { query = "@function.outer", desc = "previous method" },
          ["[c"] = { query = "@class.outer", desc = "previous class" },
          ["[j"] = { query = { "@cell.outer", "@cell.comment" }, desc = "next cell" },
        },
        goto_previous_end = {
          ["[M"] = { query = "@function.outer", desc = "previous method end" },
          ["[C"] = { query = "@class.outer", desc = "previous class end" },
        },
      },
    },
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = all_filetypes,
    callback = function()
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  })
end
