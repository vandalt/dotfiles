-- TODO: Is there a simpler way to do this?
-- https://github.com/akinsho/toggleterm.nvim/issues/542
_G.send_motion = function(motion_type)
  require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count }, true)
end
_G.send_motion_d = function()
  vim.go.operatorfunc = "v:lua.send_motion"
  return "g@"
end

return {
  {
    "GCBallesteros/jupytext.nvim",
    dev = true,
    opts = {},
  },
  {
    "toggleterm.nvim",
    keys = {
      { "<leader>il", "<Cmd>ToggleTermSendCurrentLine<CR>", desc = "Send line to terminal" },
      {
        "<leader>is", send_motion_d, desc = "Send motion to terminal", expr = true
      },
      {
        "<leader>is", function() require("toggleterm").send_lines_to_terminal("visual_selection", false, {}, true) end, desc = "Send selection to terminal", mode = "v",
      },
      { "<leader>jh", "m`vij<leader>is``", remap=true, silent=true, desc = "Toggleterm evaluate cell" },
      { "<leader>ir", "m`vig<leader>is``", remap=true, silent=true, desc = "Toggleterm run file" },
      { "<leader>jj", "vij<leader>is]j", desc = "Toggleterm evaluate cell and go to next", remap = true },
    },
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
