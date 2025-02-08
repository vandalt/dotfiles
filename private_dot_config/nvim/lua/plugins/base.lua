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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      words = { enabled = true }, -- Highlight words and lsp references
      indent = { enabled = true, animate = { enabled = true } }, -- Indent guides
      bigfile = { enabled = true }, -- Handle big files
      gitbrowse = { enabled = true },
      lazygit = { enabled = true, configure = true },
      notifier = { enabled = true, style = "compact" },
      zen = {
        enabled = true,
        toggles = { dim = false },
      },
      styles = {
        ---@diagnostic disable-next-line: missing-fields
        notification = {
          border = "single", -- default is "rounded"
          wo = { wrap = true },
        },
        ---@diagnostic disable-next-line: missing-fields
        zen = {
          backdrop = { transparent = false },
        },
        ---@diagnostic disable-next-line: missing-fields
        terminal = {
          keys = {
            term_normal = {
              ---@diagnostic disable-next-line: assign-type-mismatch
              { "<esc>", "<esc>", mode = "t" },
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference (snacks)", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference (snacks)", mode = { "n", "t" } },
      { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git browse (snacks)" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit (snacks)" },
      { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>wf",  function() Snacks.zen() end, desc = "Toggle focus mode (zen)" },
      { "<leader>wm",  function() Snacks.zen.zoom() end, desc = "Toggle maximization (zen)" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    dev = true,
    opts = {
      open_mapping = [[<c-/>]],
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.35
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
  },
}
