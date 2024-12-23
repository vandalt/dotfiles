-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable autoformat by default
vim.g.autoformat = false

vim.g.snacks_animate = false

local opt = vim.opt

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
-- opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.clipboard = ""
opt.cursorline = true  -- Enable cursorline
opt.cursorlineopt = "number"  -- Enable cursorline number color, but not full line
opt.formatoptions = "jcroqlnt"
opt.scrolloff = 4
opt.smartindent = false -- disable to allow >>ing comments in Python
opt.spelllang = { "en", "fr" }
opt.wildmode = "longest:full,full" -- Command-line completion mode
-- :h shortmess to see what each letter means (I is intro message)
opt.shortmess:append({ W = true, I = true, c = true, C = true })

opt.sessionoptions:append({"terminal"})

opt.title = true
