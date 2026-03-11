local map = require("util.config").map

local opts = { buffer = 0 }
map("i", "<CR>", "<Cmd>MkdnNewListItem<CR>", "New markdown list item", opts)
map("n", "o", "<Cmd>MkdnNewListItemBelowInsert<CR>", "New markdown list item below", opts)
map("n", "O", "<Cmd>MkdnNewListItemAboveInsert<CR>", "New markdown list item above", opts)
map({ "n", "v" }, "<C-Space>", "<Cmd>MkdnToggleToDo<CR>", "Toggle markdown todo", opts)
map({ "n", "v" }, "+", "<Cmd>MkdnIncreaseHeading<CR>", "Increase heading level", opts)
map({ "n", "v" }, "+", "<Cmd>MkdnDecreaseHeading<CR>", "Decrease heading level", opts)
map("n", "]l", "<Cmd>MkdnNextLink<CR>", "Next link", opts)
map("n", "[l", "<Cmd>MkdnPrevLink<CR>", "Prev link", opts)
map("n", "]]", "<Cmd>MkdnNextHeading<CR>", "Next heading", opts)
map("n", "[[", "<Cmd>MkdnPrevHeading<CR>", "Prev heading", opts)
map("n", "][", "<Cmd>MkdnNextHeadingSame<CR>", "Next heading same", opts)
map("n", "[]", "<Cmd>MkdnPrevHeadingSame<CR>", "Prev heading same", opts)
