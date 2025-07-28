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

-- Helps having folding with ZkNotes
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

-- From Lazyvim
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor position when opening a buffer",
  group = augroup("last-loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].my_last_loc then
      return
    end
    vim.b[buf].my_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
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
  group = augroup("wrap-spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})


vim.api.nvim_create_autocmd("FileType", {
  desc = "Force tabs of 4 in quarto documents despite frontmatter",
  group = augroup("wrap-spell"),
  pattern = { "quarto" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.spell = true
  end,
})

-- From lazyvim
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close some buffers with q directly, and don't list them",
  group = augroup("close-with-q-no-list"),
  pattern = {
    "checkhealth",
    "help",
    "grug-far",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end
})
