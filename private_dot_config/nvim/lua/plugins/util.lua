return {

  -- Toggleterm (basic terminal config)
  -- TODO: At some point I would like to replace this, in repl.lua as well
  -- with snacks.terminal
  {
    "akinsho/toggleterm.nvim",
    enabled = false,
    dev = true,
    opts = {
      size = function() return 0.30 * vim.o.lines end,
      persist_size = false,
      open_mapping = [[<C-/>]],
      responsiveness = { horizontal_breakpoint = 200 },
      shade_terminals = false,
      persist_mode = false,
    },
    keys = {
      { "<C-/>", nil, desc = "Toggleterm" },
      { "<leader>rp", "<Cmd>TermExec cmd='python %'<CR>", desc = "Run Python script" },
    },
  },

}
