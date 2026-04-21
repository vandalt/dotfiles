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
    ft = "python",
    opts = {},
  },

  -- otter.nvim
  {
    "jmbuhr/otter.nvim",
    opts = {},
    keys = {
      { "<leader>jo", function() require("otter").activate() end, desc = "Activate otter" },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = function(_, keys)
      if vim.g.vandalt_terminal ~= "snacks" then
        return keys
      end
      local mykeys = {
        {
          "<leader>jl",
          function() require("util.snacks_repl").send_lines() end,
          desc = "Send current line to terminal",
        },
        {
          "<leader>js",
          function() require("util.snacks_repl").send_lines("visual", { bracketed = true }) end,
          mode = "v",
          desc = "Send selected line to terminal",
        },
        {
          "<leader>js",
          function() return require("util.snacks_repl").send_motion_operator() end,
          desc = "Send motion to terminal",
          expr = true,
        },
        {
          "<leader>jh",
          function()
            local count = vim.v.count1
            vim.cmd("normal! m`")
            vim.api.nvim_feedkeys(
              count .. vim.api.nvim_replace_termcodes("<leader>jsij``", true, false, true),
              "m",
              false
            )
          end,
          desc = "Run cell",
          remap = true,
        },
        { "<leader>jj", "<leader>jsij]j", "Run cell and move", remap = true },
      }
      return vim.list_extend(keys, mykeys)
    end,
  },

  -- toggleterm.nvim
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    keys = {
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
          require("util.snacks_repl").send_text(text_lines, { bracketed = use_bracketed_paste })
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
