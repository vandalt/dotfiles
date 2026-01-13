return {

  -- hydra.nvim for NotebookNavigator dev
  { "nvimtools/hydra.nvim" },

  -- iron.nvim, to test NotebookNavigator
  {
    "Vigemus/iron.nvim",
    enabled = false,
    lazy = false,
    config = function()
      local view = require("iron.view")
      local opts = {
        config = {
          repl_definition = {
            python = {
              command = { "ipython", "--no-autoindent" },
              format = require("iron.fts.common").bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
          },
          -- repl_open_cmd = require("iron.view").bottom(40),
          repl_open_cmd = view.split.vertical.botright(50),
        },
      }
      require("iron.core").setup(opts)
    end,
  },

  -- Molten, to test NotebookNavigator
  {
    "benlubas/molten-nvim",
    enabled = false,
    build = ":UpdateRemotePlugins",
  },

  -- Notebook navigator for py cell objects and highlights
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dev = true,
    opts = {
      activate_hydra_keys = "<leader>jy",
      hydra_config = { hint = { position = { "top" } } },
      show_hydra_hint = true,
      hydra_keys = {
        comment = "g",
      },
      repl_provider = function(start_line, end_line, repl_args, cell_marker)
        repl_args = repl_args or {}
        if repl_args.bracketed == nil then
          repl_args.bracketed = true
        end
        require("util.snacks_repl").notebook_navigator(start_line, end_line, repl_args, cell_marker)
      end,
    },
    keys = {
      {
        "<leader>ja",
        function() require("notebook-navigator").run_cells_above() end,
        ft = "python",
        desc = "Run cell and above",
      },
      {
        "<leader>jA",
        function() require("notebook-navigator").run_all_cells() end,
        ft = "python",
        desc = "Run all cells",
      },
      {
        "<leader>jx",
        function() require("notebook-navigator").run_cell() end,
        ft = "python",
        desc = "Run python cell with NN",
      },
      {
        "<leader>jb",
        function() require("notebook-navigator").run_cells_below() end,
        ft = "python",
        desc = "Run cell and below",
      },
    },
  },

  -- mini.ai textojbects
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects["j"] = require("util").combined_cell_spec
      return opts
    end,
  },

  -- Snacks REPL mappings
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
        function() require("util.snacks_repl").send_lines("visual", { bracketed = false }) end,
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

  -- otter.nvim
  {
    "jmbuhr/otter.nvim",
    opts = {},
    keys = {
      { "<leader>jo", function() require("otter").activate() end, desc = "Activate otter" },
    },
  },
  {
    "quarto-dev/quarto-nvim",
    opts = {
      lspFeatures = { enabled = true, chunks = "all" },
      codeRunner = {
        enabled = true,
        default_method = function(cell, _)
          local text_lines = require("quarto.tools").concat(cell.text)
          require("util.snacks_repl").send(text_lines, { bracketed = true })
        end,
      },
    },
    keys = {
      { "<leader>ja", function() require("quarto.runner").run_above() end, desc = "Run cell and above" },
      { "<leader>jA", function() require("quarto.runner").run_all() end, desc = "Run all cells" },
      { "<leader>jb", function() require("quarto.runner").run_below() end, desc = "Run cell and below" },
    },
  },
}
