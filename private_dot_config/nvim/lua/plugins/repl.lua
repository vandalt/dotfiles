local trim_spaces = false
local use_bracketed_paste = true
_G.tt_opts = { trim_spaces, { args = vim.v.count }, use_bracketed_paste }

return {
  -- jupytext.nvim
  {
    "GCBallesteros/jupytext.nvim",
    dev = true,
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },

  -- NotebookNavigator.nvim
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dev = true,
    opts = {},
  },

  -- otter.nvim
  {
    "jmbuhr/otter.nvim",
    opts = {},
    keys = {
      { "<leader>jo", function() require("otter").activate() end, "Activate otter" },
    },
  },

  -- toggleterm.nvim
  -- TODO: Switch to custom snacks_repl util module, keep both for some time
  {
    "akinsho/toggleterm.nvim",
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
      {
        "<leader>jl",
        ---@diagnostic disable-next-line:param-type-mismatch
        function() require("toggleterm").send_lines_to_terminal("single_line", unpack(tt_opts)) end,
        desc = "Send current line to terminal",
      },
      {
        "<leader>js",
        ---@diagnostic disable-next-line:param-type-mismatch
        function() require("toggleterm").send_lines_to_terminal("visual_selection", unpack(tt_opts)) end,
        mode = "v",
        desc = "Send current line to terminal",
      },
      {
        "<leader>js",
        require("util").toggleterm_send_motion(tt_opts[1], tt_opts[2], tt_opts[3]),
        desc = "Send motion to terminal",
        expr = true,
      },
      { "<leader>jh", "m`<leader>jsij``", desc = "Run cell", remap = true },
      { "<leader>jj", "<leader>jsij]j", desc = "Run cell and move", remap = true },
    },
  },

  -- quarto-nvim
  {
    "quarto-dev/quarto-nvim",
    opts = {
      lspFeatures = { enabled = true, chunks = "all" },
      codeRunner = {
        enabled = true,
        default_method = function(cell, _)
          local text_lines = require("quarto.tools").concat(cell.text)
          local id = 1
          require("toggleterm").exec(text_lines, id, nil, nil, nil, nil, nil, nil, use_bracketed_paste)
        end,
      },
    },
    keys = {
      { "<leader>ja", function() require("quarto.runner").run_above() end, desc = "Run cell and above" },
      { "<leader>jA", function() require("quarto.runner").run_all() end, desc = "Run all cells" },
      { "<leader>jb", function() require("quarto.runner").run_below() end, desc = "Run cell and below" },
    },
  },

  -- nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      move = {
        keys = {
          goto_next_start = { ["]j"] = "@cell.inner" },
          goto_next_end = { ["]J"] = "@cell.outer" },
          goto_previous_start = { ["[j"] = "@cell.inner" },
          goto_previous_end = { ["[J"] = "@cell.outer" },
        },
      },
    },
  },
}
