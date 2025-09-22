local opt = vim.opt

-- Keep this near the top
vim.g.mapleader = " "

-- Dedicated venv for pynvim
vim.g.python3_host_prog = os.getenv("HOME") .. "/repos/perso/pynvim/venv/bin/python"

-- Handled by treesitter
-- See https://github.com/neovim/neovim/blob/master/runtime/ftplugin/python.vim
vim.g.no_python_maps = 1

-- Nicer netrw (when not using oil)
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+" -- Hide hidden files

vim.g.markdown_recommended_style = 0

opt.formatoptions = opt.formatoptions + "ro" -- Continue comments when pressing enter (insert and normal)
opt.number = true -- Line numbers
opt.relativenumber = true -- Relative numbers
opt.signcolumn = "yes" -- Avoids annoying movement
opt.showmode = false -- Mode is in statusline
opt.shiftwidth = 2 -- Smaller tabs because I don't code on a TV
opt.title = true
opt.expandtab = true -- Spaces
opt.ignorecase = true -- Better search
opt.smartcase = true -- Even better search
opt.undofile = true -- Persistent undo
opt.splitbelow = true
opt.splitright = true
opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- Use conform/lsp for gq<textobj>
opt.completeopt = "menu,popup,longest,fuzzy"
opt.foldlevel = 99
opt.laststatus = 3 -- Show single statusline at the bottom
