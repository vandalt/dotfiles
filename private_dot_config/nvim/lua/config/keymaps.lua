local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Yank and put current path
map("n", "yp", function() require("util").yank_path("+") end, "Yank current path")

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Normal mode (terminal)")

-- Jupyter snippets
map("n", "<leader>jn", "icodeblock<C-j>python<C-l>", "New cell", { remap = true })
map("i", "<C-CR>", "codeblock<C-j>python<C-l>", "New cell", { remap = true })
