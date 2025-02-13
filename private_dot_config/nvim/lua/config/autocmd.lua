local function augroup(name)
  return vim.api.nvim_create_augroup("vandalt-" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup("highlight-yank"),
  callback = function()
    vim.hl.on_yank()
  end
})

-- HACK: helps having folding with ZkNotes
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Set foldmethod when entering buffer",
  group = augroup("foldmethod"),
  callback = function()
    if vim.wo.foldmethod == "expr" then
      vim.schedule(function()
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end)
    end
  end
})

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Replace quickfix with trouble.nvim",
  group = augroup("trouble-quickfix"),
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd([[cclose]])
        vim.cmd([[Trouble qflist open]])
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Wrap and enable spell checking in some filetypes",
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
