return {
  "tpope/vim-sleuth",
  "tpope/vim-eunuch",
  "justinmk/vim-gtfo",
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
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
      -- { "<c-/>", "", "Toggle terminal" },
      { "<c-s-/>", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
    }
  },
}
