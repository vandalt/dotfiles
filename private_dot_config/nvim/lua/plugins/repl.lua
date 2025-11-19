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

return {

  -- Notebook navigator for py cell objects and highlights
  { "GCBallesteros/NotebookNavigator.nvim", dev = true, opts = {} },

  -- mini.ai textojbects
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects["j"] = combined_cell_spec
      return opts
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
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
      -- TODO: Integrating the next two mappings in snacks_repl would be nicer
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
    },
  },

  -- mini.hipatterns for notebook-navigator
  {
    "nvim-mini/mini.hipatterns",
    opts = function(_, opts)
      local cell_opts = { cells = require("notebook-navigator").minihipatterns_spec }
      opts.highlighters = vim.tbl_extend("error", cell_opts, opts.highlighters)
      return opts
    end,
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
