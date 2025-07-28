return {
  "tpope/vim-sleuth", -- Indent, keeping for md and qmd notebooks mostly
  "tpope/vim-eunuch", -- Shell commands
  "justinmk/vim-gtfo", -- Exit vim, keeping for gof, not using got
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "akinsho/toggleterm.nvim",
    dev = true,
    opts = {
      shade_terminals = true,
      shading_factor = "-30",
      shading_ratio = "-0.3",
      open_mapping = [[<c-/>]],
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.35
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
    keys = {
      { "<c-/>", desc = "Toggle Terminal" }, -- this key is useful to load plugin, not just desc
      { "<c-s-/>", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
      -- See source to setup with args if need it
      { "<leader>ip", "<Cmd>TermExec cmd='ipython' go_back=0<CR>", desc = "Terminal with IPython" },
      { "<leader>rp", "<Cmd>TermExec cmd='python %'<CR>", desc = "Run Python file" },
      { "<leader>rt", "<Cmd>TermExec cmd='pytest'<CR>", desc = "Run Pytest" },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- before all other start plugins
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true, -- Load main colorscheme during startup...
    event = "VeryLazy", -- Enables completion for alternative colorschemes
    -- priority = 1000, -- before all other start plugins
    opts = {
      transparent = false,
      overrides = function(colors)
        return {
          ["@string.special.url"] = { fg = colors.theme.syn.special1, underline = true, undercurl = false },
        }
      end,
      background = {
        dark = "wave",
        light = "lotus",
      }
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      -- load the colorscheme here
      -- vim.cmd([[colorscheme kanagawa]])
    end,
  }
}
