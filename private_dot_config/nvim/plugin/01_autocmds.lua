-- Autocmds ========================================================================================================
-- Some autocmds are also defined in plugin config when related to specific configs
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

-- Wrap prose languages and enable spell checking
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown", "tex", "mail" },
  callback = function()
    vim.opt_local.wrap = true
    -- Enable spell only for non-ltex languages
    -- local ltex_langs = { "plaintex", "tex", "markdown" }
    local ltex_langs = {}
    if not vim.tbl_contains(ltex_langs, vim.bo.filetype) then
      vim.opt_local.spell = true
    end
  end,
})

-- Use custom fold expression for nvim config files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    os.getenv("HOME") .. "/.config/nvim/plugin/*.lua",
    os.getenv("HOME") .. "/.local/share/chezmoi/private_dot_config/nvim/plugin/*.lua",
  },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.require('util.folds').foldexpr()"
  end,
  desc = "Use custom fold expression for nvim config files",
})

-- Force snakemake files to use shiftwidth=4
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snakemake",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
