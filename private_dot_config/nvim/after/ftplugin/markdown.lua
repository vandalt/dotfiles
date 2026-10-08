-- Enable spelling and wrap for window
vim.cmd("setlocal spell wrap")

local bufname = vim.api.nvim_buf_get_name(0)
-- Jupytext keeps notebook buffers named as .ipynb files even when ft becomes markdown.
if bufname:match("%.ipynb$") then
  vim.opt_local.shiftwidth = 4
  vim.opt_local.tabstop = 4
  vim.opt_local.softtabstop = 4
else
  vim.opt_local.shiftwidth = 2
  vim.opt_local.tabstop = 2
  vim.opt_local.softtabstop = 2
end

-- Fold with tree-sitter
vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")

-- Disable built-in `gO` mapping in favor of 'mini.basics'
vim.keymap.del("n", "gO", { buffer = 0 })

-- Set markdown-specific surrounding in 'mini.surround'
vim.b.minisurround_config = {
  custom_surroundings = {
    -- Markdown link. Common usage:
    -- `saiwL` + [type/paste link] + <CR> - add link
    -- `sdL` - delete link
    -- `srLL` + [type/paste link] + <CR> - replace link
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = require("mini.surround").user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}

-- mkdnflow mappings
local mkdn_map = function(modes, lhs, rhs, desc) vim.keymap.set(modes, lhs, rhs, { buffer = 0, desc = desc }) end

mkdn_map("i", "<CR>", "<cmd>MkdnNewListItem<cr>", "new markdown list item")
mkdn_map("n", "o", "<Cmd>MkdnNewListItemBelowInsert<CR>", "New markdown list item below")
mkdn_map("n", "O", "<Cmd>MkdnNewListItemAboveInsert<CR>", "New markdown list item above")
mkdn_map({ "n", "v" }, "<C-Space>", "<Cmd>MkdnToggleToDo<CR>", "Toggle markdown todo")
mkdn_map({ "n", "v" }, "+", "<Cmd>MkdnIncreaseHeading<CR>", "Increase heading level")
mkdn_map({ "n", "v" }, "+", "<Cmd>MkdnDecreaseHeading<CR>", "Decrease heading level")
mkdn_map("n", "]l", "<Cmd>MkdnNextLink<CR>", "Next link")
mkdn_map("n", "[l", "<Cmd>MkdnPrevLink<CR>", "Prev link")
mkdn_map("n", "]]", "<Cmd>MkdnNextHeading<CR>", "Next heading")
mkdn_map("n", "[[", "<Cmd>MkdnPrevHeading<CR>", "Prev heading")
mkdn_map("n", "][", "<Cmd>MkdnNextHeadingSame<CR>", "Next heading same")
mkdn_map("n", "[]", "<Cmd>MkdnPrevHeadingSame<CR>", "Prev heading same")
