-- https://github.com/neovim/neovim/blob/master/runtime/ftplugin/python.vim
vim.g.no_python_maps = 1

local opt = vim.opt

-- TODO: Clipboard with schedule?
opt.autowrite = false -- Autowrite when switching buffers
opt.number = true -- Line numbers
opt.relativenumber = true
opt.mouse = "a" -- Mouse everywhere
opt.showmode = false -- Show mode below status line
opt.breakindent = true -- Wrapped lines respect indent level
opt.undofile = true -- Save undo history
opt.ignorecase = true -- Case-insensitive search...
opt.smartcase = true -- except when there are capital letters
opt.signcolumn = "yes" -- Always show signcolumn to avoid shifting text
opt.updatetime = 200 -- Save swap and trigger CursorHold more frequently
opt.timeoutlen = 300 -- Time for mapped sequence to complete
opt.splitbelow = true -- Put new splits to the below
opt.splitright = true -- Put new vsplits to the right
opt.cursorline = true
opt.cursorlineopt = "number"
-- TODO: listchars?
opt.list = true  -- show some spaces and tabs
opt.inccommand = "nosplit" -- Preview substitutions in buffer
opt.scrolloff = 4 -- Context when scrolling
opt.sidescrolloff = 4 -- Context when scrolling to the side
opt.completeopt = "menu,menuone,noinsert"
opt.conceallevel = 0 -- :h conceallevel
opt.confirm = true -- Confirm save changes when exiting modified buffer
opt.expandtab = true -- spaces instead of tabs and with > or <
-- TODO: fillchars?
-- TODO: foldexpr, foldmethod, foldtext?
opt.foldlevel = 0 -- Default fold level
-- TODO: formatexpr?
opt.formatoptions = "tcqj" -- autowrap [t]ext & [c]omments, g[q] for comments, [j]oin comments
-- TODO: jumpoptions?
opt.laststatus = 3 -- Status line only on last window
opt.linebreak = true -- Wrap line in a more readable way
opt.pumblend = 10 -- Popup menu trasparency (0 is opaque)
opt.pumheight = 0 -- Max number of items in popup menu (0 uses available screen space)
opt.ruler = true -- Show ruler in statusline
opt.shiftround = true -- Round indent to multiple of shiftwidth with > and <
opt.shiftwidth = 2 -- Default indent size
opt.shortmess:append({ W = true, I = false, c = true, C = true }) -- Shorten some messages: [w]ritten, [Cc]completion, [I]ntro
opt.smartindent = true
-- TODO: statuscolumn?
opt.virtualedit = "block" -- Allow cursor where there is no text in visual block mode (c-v)
opt.wildmode = "longest:full,full" -- Go to longest match & show menu, next use full match
opt.wrap = true -- Line wrap
opt.smoothscroll = true -- Scroll screen lines instead of text lines with c-e and c-y

