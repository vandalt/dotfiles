return {

  -- snacks.nvim
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      terminal = {
        win = {
          keys = {
            nav_h = false,
            nav_j = false,
            nav_k = false,
            nav_l = false,
          },
        },
      },
    },
    keys = {
      {
        [[<C-S-/>]],
        function() Snacks.terminal.focus(nil, { cwd = vim.fn.expand("%:p:h") }) end,
        desc = "Toggle Terminal in current file dir",
        silent = true,
      },
      {
        "<leader>rp",
        function() require("util.snacks_repl").send_text("python " .. vim.fn.expand("%"), { bracketed = false }) end,
        desc = "Run Python script",
      },
      {
        "<leader>ri",
        function() require("util.snacks_repl").send_text("%run " .. vim.fn.expand("%"), { bracketed = true }) end,
        desc = "Run Python script",
      },
    },
  },

  -- toggleterm.nvim
  {
    "akinsho/toggleterm.nvim",
    enabled = vim.g.vandalt_terminal == "toggleterm",
    dev = true,
    opts = {
      size = function() return 0.30 * vim.o.lines end,
      persist_size = false,
      open_mapping = nil,
      responsiveness = { horizontal_breakpoint = 200 },
      shade_terminals = false,
      persist_mode = false,
    },
    keys = {
      { [[<C-/>]], '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle Terminal", silent = true },
      { [[<C-/>]], "<Esc><Cmd>ToggleTerm<CR>", mode = "i", desc = "Toggle Terminal", silent = true },
      { [[<C-/>]], "<Cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle Terminal", silent = true },
      {
        [[<C-S-/>]],
        function() vim.cmd("ToggleTerm dir=" .. vim.fn.expand("%:p:h")) end,
        desc = "Toggle Terminal in current file dir",
        silent = true,
      },
      { "<leader>rp", "<Cmd>TermExec cmd='python %'<CR>", desc = "Run Python script" },
    },
  },

  -- chezmoi.nvim
  {
    "xvzc/chezmoi.nvim",
    opts = {},
    keys = {
      {
        "<leader>fc",
        function() require("chezmoi.pick")[LazyVim.pick.picker.name](vim.fn.stdpath("config")) end,
        desc = "nvim config files (chezmoi)",
      },
      {
        "<leader>fz",
        function() require("chezmoi.pick")[LazyVim.pick.picker.name]() end,
        desc = "chezmoi config files",
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      local chezmoi_entry = {
        icon = " ",
        key = "c",
        desc = "Config",
        action = function() require("chezmoi.pick")[LazyVim.pick.picker.name](vim.fn.stdpath("config")) end,
      }
      local config_index
      for i = #opts.dashboard.preset.keys, 1, -1 do
        if opts.dashboard.preset.keys[i].key == "c" then
          table.remove(opts.dashboard.preset.keys, i)
          config_index = i
          break
        end
      end
      table.insert(opts.dashboard.preset.keys, config_index, chezmoi_entry)
    end,
  },
}
