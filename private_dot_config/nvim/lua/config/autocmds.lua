-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name) return vim.api.nvim_create_augroup("vandalt_" .. name, { clear = true }) end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "snakemake",
  group = augroup("snakemake_indent"),
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
  desc = "Force snakemake files to use shiftwidth=4",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("disable_pyright_snakemake"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "basedpyright" and vim.bo[args.buf].filetype == "snakemake" then
      -- ns_id does not work for now so disable all for buffer
      -- vim.diagnostic.enable(false, { bufnr = args.buf, ns_id = vim.lsp.diagnostic.get_namespace(client.id) })
      vim.diagnostic.enable(false, { bufnr = args.buf })
    end
  end,
  desc = "Disable basedpyright diagnostics for snakemake files",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("disable_ruff_otter"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufname = vim.api.nvim_buf_get_name(args.buf)

    -- Disable ruff for otter.nvim buffers
    if client and client.name == "ruff" and bufname:match("%.otter%.py$") then
      client:stop()
    end
  end,
  desc = "Disable ruff in otter buffers to let pyright show hover",
})
