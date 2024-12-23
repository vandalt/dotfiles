-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- https://github.com/LazyVim/LazyVim/issues/4509#issuecomment-2431509475
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
  -- Re-enable some useful terminal bindings overriden by LazyVim/snacks.nvim
  callback = function(ev)
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = ev.buf, nowait = true })
    vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = ev.buf, nowait = true })
    vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = ev.buf, nowait = true })
    vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = ev.buf, nowait = true })
    if vim.bo.filetype ~= "snacks_terminal" then
      vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
    end
  end,
})
