-- vim: foldmethod=marker

-- {{{ Options =========================================================================================================
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

opt.completeopt = "menu,popup,longest,fuzzy"
opt.expandtab = true -- Spaces
opt.fillchars = "eob: " -- Remove tildes at the end of signcolumn
opt.foldlevel = 99 -- Don't fold on start
opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- Use conform/lsp for gq<textobj>
opt.formatoptions = opt.formatoptions + "ro" -- Continue comments when pressing enter (insert and normal)
opt.ignorecase = true -- Better search...
opt.laststatus = 3 -- Show single statusline at the bottom
opt.number = true -- Line numbers
opt.relativenumber = true -- Relative numbers
opt.shiftwidth = 2 -- Smaller tabs because I don't code on a TV
opt.showmode = false -- Don't show mode message; it's already in statusline
opt.signcolumn = "yes" -- Avoids annoying flicker, always show signcolumn
opt.smartcase = true -- ...Even better search
opt.splitbelow = true -- Split below...
opt.splitright = true -- and to the right by default
opt.title = true -- Set window title to filename
opt.undofile = true -- Persistent undo
opt.wrap = false -- Don't wrap text by default

-- NOTE: This needs to be before hipattern and "git blame" autocmd for the highlight groups to stick
vim.cmd("colorscheme default")
-- }}}

-- {{{ Autocmds ========================================================================================================
-- NOTE: Some autocmds are also defined in 10_mini.lua and 12_plugins.lua when they are related to specific plugins

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = "term://*",
  callback = function() vim.cmd("startinsert") end,
  desc = "Enter terminal in insert mode (even when not toggleterm)",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
  callback = function(ev)
    local bufnr = ev.buf
    local edit_watch = function() require("chezmoi.commands.__edit").watch(bufnr) end
    vim.schedule(edit_watch)
  end,
  desc = "Watch chezmoi files automatically",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
  desc = "Highlight on yank",
})
-- }}}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  desc = "Do not wrap markdown",
  callback = function()
    vim.opt_local.wrap = true
  end
})
