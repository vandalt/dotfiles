local zk_start_week = "sunday"
local zk_picker
if LazyVim.pick.picker.name == "telescope" then
  zk_picker = "telescope"
elseif LazyVim.pick.picker.name == "fzf" then
  zk_picker = "fzf_lua"
else
  zk_picker = "select"
end

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
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1
    end,
  },
  {
    "3rd/image.nvim",
    opts = {
      max_width_window_percentage = 50,
      max_height_window_percentage = 33,
    },
  },
  {
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
      picker = zk_picker,
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
        function()
          require("zk").edit()
        end,
        desc = "Open note (zk)",
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
      {
        "<leader>zl",
        "<cmd>ZkLinks<CR>",
        desc = "zk Links",
      },
      {
        "<leader>zb",
        "<cmd>ZkBacklinks<CR>",
        desc = "zk Backlinks",
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
        links = true, -- Using zk for that (might want to enable for citations and mapping at some point)
      },
      mappings = {
        MkdnNextLink = { "n", "]l" },
        MkdnPrevLink = { "n", "[l" },
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
