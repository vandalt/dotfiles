local trim_spaces = false
local use_bracketed_paste = true
local tt_opts = { trim_spaces, { args = vim.v.count }, use_bracketed_paste }

-- mini.ai spec that handles python files and markdown notebooks
-- notebook-navigator is used for the former and treesitter for the latter
---@param ai_type string
---@param id string
---@param opts table<string,any>
local combined_cell_spec = function(ai_type, id, opts)
  if vim.bo.filetype == "python" then
    return require("notebook-navigator").miniai_spec(ai_type)
  else
    return require("mini.ai").gen_spec.treesitter({ a = "@cell.outer", i = "@cell.inner" })(ai_type, id, opts)
  end
end

-- TODO: Dedicated file for repl stuff?
return {
  -- mini.ai textojbects
  {
    "nvim-mini/mini.ai",
    dependencies = {
      {"GCBallesteros/NotebookNavigator.nvim", dev = true, opts = {}},
    },
    opts = function(_, opts)
      opts.custom_textobjects["j"] = combined_cell_spec
      return opts
    end,
  },

  -- Toggleterm
  -- TODO: At some point I would like to replace this
  -- with snacks.terminal
  {
    "akinsho/toggleterm.nvim",
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
      { "<leader>jh", "m`<leader>jsij``", "Run cell", remap = true },
      { "<leader>jj", "<leader>jsij]j", "Run cell and move", remap = true },
    },
  },

  -- Jupytext
  {
    -- NOTE: Should not be lazy-loaded according to docs.
    -- I tried BufReadPre but it did not work, so leaving non-lazy
    "GCBallesteros/jupytext.nvim",
    dev = true,
    opts = { style = "markdown", output_extension = "md", force_ft = "markdown" },
  },
}
