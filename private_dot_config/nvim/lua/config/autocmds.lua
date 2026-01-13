-- wrap and check for spell in text filetypes
local function augroup(name) return vim.api.nvim_create_augroup("vandalt_" .. name, { clear = true }) end

-- Replace wrap_spell to include more filetypes
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown", "tex" },
  callback = function()
    vim.opt_local.wrap = true
    -- Enable spell only for non-ltex languages
    local ltex_langs = { "plaintex", "tex", "markdown" }
    if not vim.tbl_contains(ltex_langs, vim.bo.filetype) then
      vim.opt_local.spell = true
    end
  end,
})

-- Force snakemake files to use shiftwidth=4
-- TODO: I feel like this could go in the snakemake vim plugin?
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("snakemake_indent"),
  pattern = "snakemake",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
