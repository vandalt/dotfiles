return {
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      -- style = "markdown",
      -- output_extension = "md",
      -- force_ft = "markdown",
    },
  },
  {
    "toggleterm.nvim",
    keys = {
      { "<leader>il", "<Cmd>ToggleTermSendCurrentLine<CR>", desc = "Send line to terminal" },
    }
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dev = true,
    event = "VeryLazy",
    main = "notebook-navigator",
    keys = {
      {
        "<leader>ih",
        function()
          require("notebook-navigator").run_cell({ trim_spaces = false, use_bracketed_paste = true })
        end,
        desc = "Run cell",
      },
      {
        "<leader>ii",
        function()
          require("notebook-navigator").run_and_move({ trim_spaces = false, use_bracketed_paste = true })
        end,
        desc = "Run cell and move",
      },
    },
    opts = {},
  },
  {
    "echasnovski/mini.hipatterns",
    ft = { "python" }, -- avoids empty filetype warning
    opts = function()
      return {
        highlighters = { cells = require("notebook-navigator").minihipatterns_spec },
      }
    end,
  },
  {
    "echasnovski/mini.ai",
    opts = function()
      local ai = require("mini.ai")
      return {
        -- TODO: Add to which-key
        custom_textobjects = {
          j = require("notebook-navigator").miniai_spec,
          u = ai.gen_spec.function_call(),
          -- Buffer
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
    end,
  },
}
