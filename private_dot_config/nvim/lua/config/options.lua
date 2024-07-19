-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable autoformat by default
vim.g.autoformat = false

local opt = vim.opt

-- Options that lazyvim sets that I might want to change in the future
if not vim.env.SSH_TTY then
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  opt.clipboard = "unnamedplus" -- Sync with system clipboard
end
opt.formatoptions = "jcroqlnt" -- tcqj
opt.smartindent = false -- disable to allow >>ing comments in Python
opt.spelllang = { "en", "fr" }
opt.wildmode = "longest:full,full" -- Command-line completion mode
-- :h shortmess to see what each letter means (I is intro message)
opt.shortmess:append({ W = true, I = true, c = true, C = true })
