-- Global editor variables
vim.g.autoformat = false
vim.g.deprecation_warnings = true
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.sidekick_nes = false
vim.g.snacks_animate = false

vim.g.vandalt_terminal = "snacks"
vim.g.vandalt_dashboard = false

-- Options
local opt = vim.opt
opt.spelllang = { "fr", "en" } -- Franglais
opt.formatoptions = "jcroqlnt" -- tcqj
opt.title = true -- Set window title to filename
-- opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor" -- Block cursor all the time
if not vim.g.vandalt_dashboard then
  opt.shortmess:remove("I")  -- Keep intro message if no dashboard
end
