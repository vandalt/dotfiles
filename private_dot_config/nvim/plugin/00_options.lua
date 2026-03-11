-- Editor variables ================================================================================================
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

-- Handle markdown style, tabs, maps, etc. myself
vim.g.markdown_recommended_style = 0
vim.g.no_markdown_maps = true -- Does not remove treesitter mappings

-- Disable autopairs by default
vim.g.minipairs_disable = true


-- Options =========================================================================================================
local opt = vim.opt

opt.completeopt = "menu,popup,longest,fuzzy"
opt.expandtab = true -- Spaces
opt.fillchars = "eob: " -- Remove tildes at the end of signcolumn
opt.foldlevel = 99 -- Don't fold on start
opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- Use conform/lsp for gq<textobj>
opt.formatoptions = opt.formatoptions + "ro" -- Continue comments when pressing enter (insert and normal)
opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block,t:block-blinkon500-blinkoff500-TermCursor" -- Block cursor
opt.ignorecase = true -- Better search...
opt.laststatus = 3 -- Show single statusline at the bottom
opt.number = true -- Line numbers
opt.relativenumber = true -- Relative numbers
opt.shiftwidth = 2 -- Smaller tabs because I don't code on a TV
opt.showmode = false -- Don't show mode message; it's already in statusline
opt.signcolumn = "yes" -- Avoids annoying flicker, always show signcolumn
opt.smartcase = true -- ...Even better search
opt.spelllang = { "fr", "en" } -- Franglais
opt.splitbelow = true -- Split below...
opt.splitright = true -- ...and to the right by default
opt.title = true -- Set window title to filename
opt.undofile = true -- Persistent undo
opt.wrap = false -- Don't wrap text by default
