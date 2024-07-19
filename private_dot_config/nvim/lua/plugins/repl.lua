local function openSlimeTerm()
  local id = vim.fn.system("kitty @ launch --type=os-window --cwd=current")
  local new_config = { window_id = id, listen_on = "" }
  -- Make sure buffer from where new terminal is created gets updated
  vim.b.slime_config = new_config
  -- New buffers will use latest terminal by default
  vim.g.slime_default_config = new_config
end

local function updateSlimeDefaultConfig()
  vim.b.slime_config = vim.g.slime_default_config
end

local function openPythonREPL()
  openSlimeTerm()
  -- TODO: Check for venv otherwise do nothing
  vim.fn.system("kitty @ send-text 'pact; cd notebooks; ipython'\\\\x0D")
end

local function openJuliaREPL()
  openSlimeTerm()
  vim.fn.system("kitty @ send-text 'julia'\\\\x0D")
end

return {
  {
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_target = "kitty"
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_no_mappings = 1
      vim.g.slime_cell_delimiter = "# %%"
      -- TODO: Setup markdown as well
      -- vim.g.slime_cell_delimiter = "```"
      -- vim.g.slime_python_ipython = 1
      vim.g.slime_bracketed_paste = 1
      vim.keymap.set("n", "<leader>it", openSlimeTerm, { desc = "Open terminal for Slime" })
      vim.keymap.set("n", "<leader>ir", openPythonREPL, { desc = "Open IPython REPL" })
      vim.keymap.set("n", "<leader>ij", openJuliaREPL, { desc = "Open Julia REPL" })
      vim.keymap.set("n", "<leader>ic", "<Plug>SlimeConfig", { desc = "Set slime config" })
      vim.keymap.set("n", "<leader>iu", updateSlimeDefaultConfig, { desc = "Update slime config to latest default" })
      vim.keymap.set("n", "<leader>il", "<Plug>SlimeLineSend", { desc = "Send line to REPL" })
      vim.keymap.set("n", "<leader>is", "<Plug>SlimeMotionSend", { desc = "Send motion to REPL" })
      vim.keymap.set("x", "<leader>is", "<Plug>SlimeRegionSend", { desc = "Send selection to REPL" })
      vim.keymap.set("n", "<leader>ib", "<Plug>SlimeParagraphSend", { desc = "Send paragraph (block) to REPL" })
      vim.keymap.set("n", "<leader>ih", "<Plug>SlimeSendCell", { desc = "Send cell to REPL" })
      -- TODO: Proper dependency management for this mapping
      vim.keymap.set("n", "<leader>ii", "<leader>ih]j", { remap = true, desc = "Send cell to REPL and go to the next" })
    end,
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    -- Make sure toggleterm is installed to silence REPL warning
    dependencies = { "akinsho/toggleterm.nvim" },
    keys = {
      {
        "]j",
        function()
          require("notebook-navigator").move_cell("d")
        end,
      },
      {
        "[j",
        function()
          require("notebook-navigator").move_cell("u")
        end,
      },
    },
    event = "VeryLazy",
    config = true,
  },
  {
    "GCBallesteros/jupytext.nvim",
    -- config = true,
    opts = {
      custom_language_formatting = {
        -- TODO Set this up. It's a bit slow when saving for now
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto", -- you can set whatever filetype you want here
        },
        -- python = {
        --   extension = "md",
        --   style = "markdown",
        --   force_ft = "markdown", -- you can set whatever filetype you want here
        -- },
      }
    },
  },
  {
    -- otter provides LSP in embedded code blocks
    "jmbuhr/otter.nvim",
    -- NOTE: The minimal config with no opts works, but will use the default
    -- It requires activating otter for the current buffer with `require("otter").activate()`
    -- and then using `require("otter").whatever_command()` to run other commands.
    dependencies = {
      "hrsh7th/nvim-cmp", -- optional, for completion
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp = {
        hover = {
          -- Disable borders so looks more like default LSP
          border = { "", "", "", "", "", "", "", "" },
        },
      },
      buffers = {
        set_filetype = true,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      "jmbuhr/otter.nvim",
    },
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        -- Add otter to cmp sources
        table.insert(opts.sources, { name = "otter" })
      end
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua and
      -- added as a nvim-cmp source in lua/plugins/completion.lua
      -- TODO: Otter config
      -- TODO: LSP and cmp integration
      -- TODO: Other deps like treesitter and lspconfig?
      "jmbuhr/otter.nvim",
    },
    opts = {
      lspFeatures = {
        -- TODO: Can we just remove this and have it for all known languages?
        languages = { "r", "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
        chunks = "all", -- Detect language for chunks without curly braces too (regular markdown format)
      },
      diagnostics = {
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "slime",
      },
      -- keymap = {
      --   -- Defaults are lr/lf, but I want same as regular LSP
      --   rename = "<leader>cr",
      --   format = "<leader>cf",
      -- },
    },
    keys = {
      {
        "<leader>qp",
        function()
          require("quarto").quartoPreview()
        end,
        desc = "Quarto preview"
      },
      {
        "<leader>qs",
        function()
          require("quarto").activate()
        end,
        desc = "Quarto activate"
      },
      {
        "<leader>qc",
        function()
          require("quarto.runner").run_cell()
        end,
        desc = "Quarto run cell",
      },
      {
        "<leader>qa",
        function()
          require("quarto.runner").run_above()
        end,
        desc = "Quarto run above",
      },
      {
        "<leader>qr",
        function()
          require("quarto.runner").run_all()
        end,
        desc = "Quarto run all",
      },
      {
        "<leader>ql",
        function()
          require("quarto.runner").run_line()
        end,
        desc = "Quarto run line",
      },
      {
        "<leader>qr",
        function()
          require("quarto.runner").run_all()
        end,
        desc = "Quarto run visual range",
        mode = { "v" },
      },
    },
  },
}
