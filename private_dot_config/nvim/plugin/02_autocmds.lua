-- Enter terminal in insert mode (even when not toggleterm)
vim.api.nvim_create_autocmd(
  { "TermOpen", "BufEnter" },
  { pattern = "term://*", callback = function() vim.cmd("startinsert") end }
)

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})
