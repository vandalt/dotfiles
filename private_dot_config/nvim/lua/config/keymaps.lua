local map = vim.keymap.set

map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Close buffer" })
map("n", "<leader>bD", "<Cmd>bdelete<CR>", { desc = "Close buffer and window" })
map({ "n", "i" }, "<Esc>", "<Cmd>nohlsearch<CR><esc>", { desc = "Clear hlsearch" })
map("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "View diagnostic" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Clipboard things
map({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" , remap=true})
map("n", "<leader>Y", [["+Y]], { desc = "Yank EOL to system clipboard", remap=true})
map({"n", "v"}, "<leader>p", [["+p]], { desc = "Put from system clipboard after cursor" , remap=true})
map({"n", "v"}, "<leader>P", [["+P]], { desc = "Put from system clipboard before cursor", remap=true})


-- stylua: ignore start
map("n", "]d", function() vim.diagnostic.jump({ count = vim.v.count1, float = true }) end)
map("n", "[d", function() vim.diagnostic.jump({ count = -vim.v.count1, float = true }) end)
-- stylua: ignore end

-- better up/down, stolen from LazyVim
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys, stolen from LazyVim
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })


-- Mange split windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Resize window using <ctrl> arrow keys, stolen from LazyVim
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines, stolen from LazyVim
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })


map("i", "<A-d>", "📅", { desc = "Insert calendar (date) emoji"})
