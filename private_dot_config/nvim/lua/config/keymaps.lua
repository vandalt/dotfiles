local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Yank and put current path
map("n", "yp", function() require("util").yank_path("+") end, "Yank current path")

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Normal mode (terminal)")

-- Undotree
map("n", "<leader>uu", "<Cmd>Undotree<CR>", "Toggle Undotree")

-- Clear white spaces
map("n", "<leader>cw", function()
  local view = vim.fn.winsaveview()
  vim.cmd("%s/\\s\\+$//e")
  vim.fn.winrestview(view)
end, "Clear whitespace")

-- Remove swap file
map("n", "<leader>rs", function()
  local swapfile = vim.fn.swapname(vim.fn.bufnr())
  swapfile = swapfile:gsub("%.swo$", ".swp")
  if swapfile and swapfile ~= "" then
    vim.fn.delete(swapfile)
    vim.notify("Removed swap file: " .. swapfile, vim.log.levels.INFO)
  else
    vim.notify("No swap file found", vim.log.levels.WARN)
  end
end, "Remove swap file")

-- Jupyter snippets
map("n", "<leader>jn", "icodeblock<C-j>python<C-l>", "New cell", { remap = true })
map("i", "<C-CR>", "codeblock<C-j>python<C-l>", "New cell", { remap = true })
