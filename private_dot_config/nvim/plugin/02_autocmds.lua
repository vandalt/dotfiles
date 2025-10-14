-- Enter terminal in insert mode (even when not toggleterm)
vim.api.nvim_create_autocmd(
  { "TermOpen", "BufEnter" },
  { pattern = "term://*", callback = function() vim.cmd("startinsert") end }
)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
  callback = function(ev)
    local bufnr = ev.buf
    local edit_watch = function() require("chezmoi.commands.__edit").watch(bufnr) end
    vim.schedule(edit_watch)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})

-- NOTE: This needs to be before hipattern and split autocmd for the highlight groups to stick
vim.cmd("colorscheme default")
-- Extra highlight groups
vim.api.nvim_set_hl(0, "GitBlameHashRoot", { link = "Tag" })
vim.api.nvim_set_hl(0, "GitBlameHash", { link = "Identifier" })
vim.api.nvim_set_hl(0, "GitBlameAuthor", { link = "String" })
vim.api.nvim_set_hl(0, "GitBlameDate", { link = "Comment" })
-- Autocmd to keep verticL git blame aligned with the buffer
-- https://github.com/nvim-mini/mini.nvim/discussions/2029
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitCommandSplit",
  callback = function(au_data)
    if au_data.data.git_subcommand ~= "blame" then
      return
    end

    local win_src = au_data.data.win_source
    local buf = au_data.buf
    local win = au_data.data.win_stdout

    -- Opts
    vim.bo[buf].modifiable = false
    vim.wo[win].wrap = false
    vim.wo[win].cursorline = true
    -- View
    vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
    vim.wo[win].scrollbind, vim.wo[win_src].scrollbind = true, true
    vim.wo[win].cursorbind, vim.wo[win_src].cursorbind = true, true
    -- Vert width
    if au_data.data.cmd_input.mods:match("vertical") then
      local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
      local width = vim.iter(lines):fold(-1, function(acc, ln)
        local stat = string.match(ln, "^%S+ %b()")
        return math.max(acc, vim.fn.strwidth(stat))
      end)
      width = width + vim.fn.getwininfo(win)[1].textoff
      vim.api.nvim_win_set_width(win, width)
    end

    -- Highlight
    vim.fn.matchadd("GitBlameHashRoot", [[^^\w\+]])
    vim.fn.matchadd("GitBlameHash", [[^\w\+]])
    local leftmost = [[^.\{-}\zs]]
    vim.fn.matchadd("GitBlameAuthor", leftmost .. [[(\zs.\{-} \ze\d\{4}-]])
    vim.fn.matchadd("GitBlameDate", leftmost .. [[[0-9-]\{10} [0-9:]\{8} [+-]\d\+]])
  end,
})
