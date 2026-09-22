local bufname = vim.api.nvim_buf_get_name(0)

-- Jupytext keeps notebook buffers named as .ipynb files even when ft becomes markdown.
if bufname:match("%.ipynb$") then
  vim.opt_local.shiftwidth = 4
  vim.opt_local.tabstop = 4
  vim.opt_local.softtabstop = 4
end
