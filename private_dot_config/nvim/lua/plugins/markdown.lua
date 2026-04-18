return {

  -- marksman (disable)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = { enabled = false },
      },
    },
  },

  -- render-markdown.nvim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        enabled = true,
        conceal_delimiters = true,
        language = true,
        border = "thick",
      },
    },
  },

  -- markdown-preview.nvim
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
  },

  -- zk-nvim
  {
    "zk-org/zk-nvim",
    name = "zk",
    opts = {
      picker = "snacks_picker",
    },
    keys = {
      -- stylua: ignore start
      { "<leader>z", desc = "+zk", mode = {"n", "x"}},
      {"<leader>zo", function() require("zk").edit() end, desc = "Open zk note"},
      {"<leader>zl", "<Cmd>ZkLinks<CR>", desc = "Open zk links"},
      {"<leader>zb", "<Cmd>ZkBacklinks<CR>", desc = "Open zk backlinks"},
      {"<leader>zw", function() require("zk").new({ dir = "weekly", date = require("util").get_date_zw() }) end, desc = "Weekly note (zk)"},
      {"<leader>zd", function() require("zk").new({ dir = "daily" }) end, desc = "Daily note (zk)"},
      {"<leader>zn", function() require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" }) end, desc = "New Note (zk)"},
      { "<leader>zn", ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<CR>", mode = "x", desc = "New note from title selection",  silent = true },
      { "<leader>zc", ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: '), dir = 'zettel' }<CR>", mode = "x", desc = "New note from content selection"},
      -- stylua: ignore end
    },
  },

  -- mkdnflow
  {
    "jakewvincent/mkdnflow.nvim",
    opts = {
      modules = {
        bib = false,
        buffers = false,
        conceal = false,
        cursor = true,
        folds = false,
        foldtext = false,
        links = false,
        lists = true,
        maps = false,
        paths = false,
        tables = false,
        templates = false,
        to_do = true,
        yaml = false,
        completion = false,
        notebook = false,
      },
    },
    keys = {
      { "<cr>", "<cmd>MkdnNewListItem<cr>", mode = "i", desc = "new markdown list item", ft = "markdown" },
      { "o", "<Cmd>MkdnNewListItemBelowInsert<CR>", desc = "New markdown list item below", ft = "markdown" },
      { "O", "<Cmd>MkdnNewListItemAboveInsert<CR>", desc = "New markdown list item above", ft = "markdown" },
      { "<C-Space>", "<Cmd>MkdnToggleToDo<CR>", mode = { "n", "v" }, desc = "Toggle markdown todo", ft = "markdown" },
      { "+", "<Cmd>MkdnIncreaseHeading<CR>", mode = { "n", "v" }, desc = "Increase heading level", ft = "markdown" },
      { "+", "<Cmd>MkdnDecreaseHeading<CR>", mode = { "n", "v" }, desc = "Decrease heading level", ft = "markdown" },
      { "]l", "<Cmd>MkdnNextLink<CR>", desc = "Next link", ft = "markdown" },
      { "[l", "<Cmd>MkdnPrevLink<CR>", desc = "Prev link", ft = "markdown" },
      { "]]", "<Cmd>MkdnNextHeading<CR>", desc = "Next heading", ft = "markdown" },
      { "[[", "<Cmd>MkdnPrevHeading<CR>", desc = "Prev heading", ft = "markdown" },
      { "][", "<Cmd>MkdnNextHeadingSame<CR>", desc = "Next heading same", ft = "markdown" },
      { "[]", "<Cmd>MkdnPrevHeadingSame<CR>", desc = "Prev heading same", ft = "markdown" },
    },
  },
}
