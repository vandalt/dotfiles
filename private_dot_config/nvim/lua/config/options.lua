-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.deprecation_warnings = true
vim.g.lazyvim_python_lsp = "basedpyright"

-- Workaround to set background automatically in tmux
-- Ref: https://github.com/neovim/neovim/issues/17070
if vim.loop.os_gethostname() ~= "yoga" then
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.loop.fs_write(2, "\27Ptmux;\27\27]11;?\7\27\\", -1, nil)
end

vim.opt.spelllang = { "fr", "en" }
vim.opt.title = true
