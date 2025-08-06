-- https://github.com/neovim/neovim/blob/master/runtime/ftplugin/python.vim
vim.g.no_python_maps = 1
vim.g.python3_host_prog = os.getenv("HOME") .. "/repos/perso/pynvim/venv/bin/python"

-- function Foldexpr()
--   -- Copied from lazyvim
--   local buf = vim.api.nvim_get_current_buf()
--   if vim.b[buf].ts_folds == nil then
--     -- as long as we don't have a filetype, don't bother
--     -- checking if treesitter is available (it won't)
--     if vim.bo[buf].filetype == "" then
--       return "0"
--     end
--     if vim.bo[buf].filetype:find("dashboard") then
--       vim.b[buf].ts_folds = false
--     else
--       vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
--     end
--   end
--   return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
-- end

local opt = vim.opt

opt.autowrite = false -- Autowrite when switching buffers
opt.number = true -- Line numbers
opt.relativenumber = true
opt.mouse = "a" -- Mouse everywhere
opt.title = true -- Set title based on filename
opt.showmode = false -- Show mode below status line
opt.breakindent = true -- Wrapped lines respect indent level
opt.undofile = true -- Save undo history
opt.ignorecase = true -- Case-insensitive search...
opt.smartcase = true -- except when there are capital letters
opt.signcolumn = "yes" -- Always show signcolumn to avoid shifting text
opt.updatetime = 200 -- Save swap and trigger CursorHold more frequently
opt.timeoutlen = 300 -- Time for mapped sequence to complete
opt.timeout = true
opt.splitbelow = true -- Put new splits to the below
opt.splitright = true -- Put new vsplits to the right
opt.cursorline = true
opt.cursorlineopt = "number"
opt.list = true -- show some spaces and tabs
opt.inccommand = "nosplit" -- Preview substitutions in buffer
opt.scrolloff = 4 -- Context when scrolling
opt.sidescrolloff = 4 -- Context when scrolling to the side
opt.completeopt = "menu,menuone,noinsert"
opt.conceallevel = 0 -- :h conceallevel
opt.confirm = true -- Confirm save changes when exiting modified buffer
opt.expandtab = true -- spaces instead of tabs and with > or <
opt.formatoptions = "tcqjro" -- autowrap [t]ext & [c]omments, g[q] for comments, [j]oin comments
opt.laststatus = 3 -- Status line only on last window
opt.linebreak = true -- Wrap line in a more readable way
opt.pumblend = 10 -- Popup menu trasparency (0 is opaque)
opt.pumheight = 0 -- Max number of items in popup menu (0 uses available screen space)
opt.ruler = true -- Show ruler in statusline
opt.shiftround = true -- Round indent to multiple of shiftwidth with > and <
opt.shiftwidth = 2 -- Default indent size
opt.tabstop = 2 -- Tab size
opt.shortmess:append({ W = true, I = false, c = true, C = true }) -- Shorten some messages: [w]ritten, [Cc]completion, [I]ntro
opt.smartindent = false -- Disble so >> and << work in Python
opt.virtualedit = "block" -- Allow cursor where there is no text in visual block mode (c-v)
opt.wildmode = "longest:full,full" -- Go to longest match & show menu, next use full match
opt.wrap = true -- Line wrap
opt.smoothscroll = true -- Scroll screen lines instead of text lines with c-e and c-y
opt.foldmethod = "expr"
-- opt.foldexpr = "v:lua.Foldexpr()"
opt.foldtext = "" -- Makes mkdnflow foldtext work
opt.foldlevel = 99
opt.spelllang = { "en", "fr" }


---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

-- Prevent ftplugin from setting markdown indent to 4
vim.g.markdown_recommended_style = 0
