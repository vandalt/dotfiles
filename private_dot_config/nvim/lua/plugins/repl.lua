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
    -- Should not be lazy-loaded according to docs.
    -- I tried BufReadPre but it did not work
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
    enabled = true,
    lazy = true,
    main = "notebook-navigator",
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
    event = "VeryLazy",
    opts = function(_, opts)
      local new_opts = {
        custom_textobjects = {
          j = require("notebook-navigator").miniai_spec,
        },
      }
      return vim.tbl_deep_extend("error", opts, new_opts)
    end,
  },
}
