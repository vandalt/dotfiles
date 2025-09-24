-- Enter terminal in insert mode (even when not toggleterm)
vim.api.nvim_create_autocmd(
  { "TermOpen", "BufEnter" },
  { pattern = "term://*", callback = function() vim.cmd("startinsert") end }
)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
    callback = function(ev)
        local bufnr = ev.buf
        local edit_watch = function()
            require("chezmoi.commands.__edit").watch(bufnr)
        end
        vim.schedule(edit_watch)
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})
