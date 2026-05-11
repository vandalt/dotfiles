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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  group = augroup("oil_statuscolumn"),
  callback = function() vim.opt_local.statuscolumn = "" end,
  desc = "Hide statuscolumn in oil buffers",
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
