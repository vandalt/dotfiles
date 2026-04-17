-- Global editor variables
vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.deprecation_warnings = true
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.sidekick_nes = false

vim.g.vandalt_terminal = "snacks"
vim.g.vandalt_dashboard = true

-- Options
local opt = vim.opt
opt.spelllang = { "fr", "en" } -- Franglais
opt.title = true -- Set window title to filename
if not vim.g.vandalt_dashboard then
  opt.shortmess:remove("I")  -- Keep intro message if no dashboard
end
