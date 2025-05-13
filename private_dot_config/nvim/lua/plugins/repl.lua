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
    "toggleterm.nvim",
    keys = {
      {
        "<leader>il",
        function()
          require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count }, false)
        end,
        desc = "Send line to terminal",
      },
      {
        "<leader>is",
        send_motion_d,
        desc = "Send motion to terminal",
        expr = true,
      },
      {
        "<leader>is",
        function()
          require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = vim.v.count }, true)
        end,
        desc = "Send selection to terminal",
        mode = "v",
      },
      { "<leader>jh", "m`vij<leader>is``", remap = true, silent = true, desc = "Toggleterm evaluate cell" },
      { "<leader>ir", "m`vig<leader>is``", remap = true, silent = true, desc = "Toggleterm run file" },
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
  {
    -- NOTE: Should not be lazy-loaded according to docs.
    -- I tried BufReadPre but it did not work
    "GCBallesteros/jupytext.nvim",
    dev = true,
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },
  {
    "benlubas/molten-nvim",
    enabled = false,
    build = ":UpdateRemotePlugins",
    cmd = { "MoltenInit" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_cover_empty_lines = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = false
      vim.g.molten_output_win_max_height = 40
    end,
    keys = {
      { "<leader>ji", "<Cmd>MoltenInit<CR>", desc = "Initialize Molten" },
      { "<leader>jl", "<Cmd>MoltenEvaluateLine<CR>", desc = "Molten evaluate line" },
      { "<leader>jo", "<Cmd>MoltenEvaluateOperator<CR>", desc = "Molten evaluate operator" },
      { "<leader>je", "<Cmd>noautocmd MoltenEnterOutput<CR>", desc = "Molten enter output" },
      { "<leader>jq", "<Cmd>MoltenHideOutput<CR>", desc = "Molten hide output" },
      { "<leader>j", "<Cmd>MoltenEvaluateVisual<CR>", mode = "v", desc = "Molten evaluate selection" },
      { "<leader>jh", "vij<leader>j<Esc>", remap = true, silent = true, desc = "Molten evaluate cell" },
      { "<leader>jj", "vij<leader>j<Esc>]j", desc = "Molten evaluate cell and go to next", remap = true },
    },
  },
  {
    "jmbuhr/otter.nvim",
    dev = true,
    opts = function()
      return {
        -- lsp = {
        --   -- diagnostic_update_events = { "BufWritePost" },
        --   diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
        -- },
        buffers = {
          set_filetype = true,
          write_to_disk = true,
        },
        -- debug = false,
      }
    end,
    keys = {
      {
        "<leader>ja",
        function()
          require("otter").activate()
        end,
        desc = "Activate otter",
      },
      {
        "<leader>jd",
        function()
          require("otter").deactivate()
        end,
        desc = "Deactivate otter",
      },
    },
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = { "jmbuhr/otter.nvim" },
    opts = {
      debug = true,
      lspFeatures = {
        enabled = true,
        chunks = "plain",
      },
      codeRunner = {
        default_method = function(cell, _)
          local concat = require("quarto.tools").concat
          local text_lines = concat(cell.text)
          local id = 1
          local use_bracketed_paste = true
          require("toggleterm").exec(text_lines, id, nil, nil, nil, nil, nil, nil, use_bracketed_paste)
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>qp", function() require("quarto").quartoPreview({}) end, desc = "Preview Quarto" },
      { "<leader>qa", function() require("quarto").activate() end, desc = "Activate Quarto" },
      { "<leader>re", function() require("quarto.runner").run_cell() end, desc = "Run cell" },
      { "<leader>rr", "<leader>rc]j", desc = "Run cell" , remap = true },
      { "<leader>ra", function() require("quarto.runner").run_above() end, desc = "Run cell and above" },
      { "<leader>rb", function() require("quarto.runner").run_below() end, desc = "Run cell and below" },
      { "<leader>rA", function() require("quarto.runner").run_all() end, desc = "Run all cells" },
      { "<leader>rl", function() require("quarto.runner").run_line() end, desc = "Run line" },
      { "<leader>r",  function() require("quarto.runner").run_range() end, mode = "v", desc = "Run visual range" },
    }
,
  },
}
