local add = require("mini.deps").add

local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "main",
  monitor = "main",
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end,
  },
})
add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })
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

-- Move around text object (selection is configured with mini.ai)
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
