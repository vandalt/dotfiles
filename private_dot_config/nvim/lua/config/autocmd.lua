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

vim.api.nvim_create_autocmd("BufReadPost", {
  -- HACK: helps having folding with ZkNotes
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



-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
--   group = augroup("diagnosticchanged"),
--   callback = function(args)
--     vim.print(args.data)
--   end
-- })

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   group = augroup("last-loc"),
--   callback = function(event)
--     local exclude = { "gitcommit" }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
--       return
--     end
--     vim.b[buf].last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })
