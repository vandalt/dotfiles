vim.g.autoformat = false -- toggle with <leader>uf
vim.g.snacks_animate = false -- toggle with <leader>ua

local opt = vim.opt

opt.clipboard = ""
opt.cursorline = true  -- Enable cursorline
opt.cursorlineopt = "number"  -- Enable cursorline number color, but not full line
opt.formatoptions = "jcroqlnt"
opt.scrolloff = 4
opt.smartindent = false -- disable to allow >>ing comments in Python
opt.spelllang = { "en", "fr" }
opt.wildmode = "longest:full,full" -- Command-line completion mode
-- :h shortmess to see what each letter means (I removes intro mesage message)
opt.shortmess:append({ W = true, I = false, c = true, C = true })
opt.sessionoptions:append({"terminal"}) -- Add terminl buffers to saved sessions

opt.title = true
