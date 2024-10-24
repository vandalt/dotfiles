local zk_start_week = "sunday"
local function get_date_zw(start_week_day)
  start_week_day = start_week_day or "sunday"
  -- TODO: 'Start week day stays sunday, but day determining which week to use should be
  ---@diagnostic disable-next-line: assign-type-mismatch
  if string.lower(os.date("%A")) == start_week_day then
    return "today"
  else
    return start_week_day
  end
end

return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      -- Open a new window when starting preview
      -- vim.cmd([[
      --   function OpenMarkdownPreview (url)
      --   execute "silent ! firefox --new-window " . a:url
      --   endfunction
      -- ]])
      -- vim.g.mkdp_browserfunc = "OpenMarkdownPreview"

      -- Don't auto-close window when leaving file
      vim.g.mkdp_auto_close = 0
      -- Reuse preview window when switching files
      -- (requires mkdb_auto_close = 0)
      vim.g.mkdp_combine_preview = 1
    end,
  },
  -- from lazyvim
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = function()
  --     require("lazy").load({ plugins = { "markdown-preview.nvim" } })
  --     vim.fn["mkdp#util#install"]()
  --   end,
  --   keys = {
  --     {
  --       "<leader>cp",
  --       ft = "markdown",
  --       "<cmd>MarkdownPreviewToggle<cr>",
  --       desc = "Markdown Preview",
  --     },
  --   },
  --   config = function()
  --     vim.cmd([[do FileType]])
  --   end,
  -- },
  {
    -- NOTE: Using a fork until "checkhealth" issue is fixed
    -- "ekickx/clipboard-image.nvim",
    "dfendr/clipboard-image.nvim",
    opts = {
      default = {
        img_dir = { "%:p:h", "img" },
      },
    },
    keys = {
      { "<leader>mi", "<Cmd>PasteImg<CR>", desc = "Paste image" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Using zk instead. Could enable outside "notes" directory?
        marksman = { autostart = false },
      },
    },
  },
  {
    "zk-org/zk-nvim",
    -- Plugin name that lazy should use for require(name).setup(opts)
    name = "zk",
    ft = { "markdown" },
    opts = {
      -- Use telescope (with dressing.nvim, "select" gives something similar)
      picker = "telescope",
    },
    cmd = { "ZkNotes", "ZkTags", "ZkLinks", "ZkBacklinks", "ZkMatch", "ZkNew" },
    keys = {
      -- Create new note, ask for title
      {
        "<leader>zn",
        function()
          require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" })
        end,
        desc = "New Note (zk)",
      },
      -- Create new note using selection as title
      {
        "<leader>zn",
        ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<CR>",
        mode = { "x" },
        desc = "New note from title selection",
      },
      -- Fuzzy search notes based on titles (use regular file picker for file names)
      {
        "<leader>zo",
        function() require("zk").edit() end,
        desc = "Open note (zk)"
      },
      -- Create new note using selection as content, ask for title
      {
        "<leader>zc",
        ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: '), dir = 'zettel' }<CR>",
        mode = { "x" },
        desc = "New note from content selection",
      },
      -- Create and/or open weekly note
      {
        "<leader>zw",
        function()
          require("zk").new({ dir = "weekly", date = get_date_zw(zk_start_week) })
        end,
        desc = "Weekly log (zk)",
      },
      {
        "<leader>zm",
        function()
          require("zk").new({ title = "Quick Notes" })
        end,
        desc = "Working memory (zk)",
      },
      -- Create and/or open daily note
      {
        "<leader>zd",
        function()
          require("zk").new({ dir = "daily" })
        end,
        desc = "Daily note (zk)",
      },
    },
  },
  {
    "jakewvincent/mkdnflow.nvim",
    opts = {
      modules = {
        buffers = false, -- Disable navigation with Backspace and Del - Use C-I and C-O
        folds = false, -- Use default vim folding
        conceal = false, -- Use default treesitter conceal
        links = false, -- Using zk for that (might want to enable for citations at some point)
      },
      mappings = {
        -- Enable in insert mode: lists and tables
        -- Disable in normal and visual (link-related things)
        MkdnEnter = { "i", "<CR>" },
        -- Default "-" conflicts with oil.nvim
        MkdnDecreaseHeading = { "n", "=" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", os.getenv("HOME") .. "/.config/markdownlint/config.markdownlint.yaml" },
        },
      },
    },
  },
}
