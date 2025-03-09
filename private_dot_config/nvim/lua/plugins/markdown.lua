local zk_start_week = "sunday"
local function get_date_zw(start_week_day)
  start_week_day = start_week_day or zk_start_week
  ---@diagnostic disable-next-line: param-type-mismatch
  if string.lower(os.date("%A")) == start_week_day then
    return "today"
  else
    return start_week_day
  end
end

return {
  {
    "zk-org/zk-nvim",
    main = "zk",
    cmd = { "ZkNotes", "ZkIndex", "ZkNew" },
    opts = {
      picker = "telescope",
    },
    keys = {
      {
        "<leader>zn",
        function()
          require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" })
        end,
        desc = "New Note (zk)",
      },
      {
        "<leader>zn",
        ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<CR>",
        mode = { "x" },
        desc = "New note from title selection",
      },
      {
        "<leader>zo",
        function()
          require("zk").edit()
        end,
        desc = "Open note (zk)",
      },
      {
        "<leader>zc",
        ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: '), dir = 'zettel' }<CR>",
        mode = { "x" },
        desc = "New note from content selection",
      },
      {
        "<leader>zw",
        function()
          require("zk").new({ dir = "weekly", date = get_date_zw(zk_start_week) })
        end,
        desc = "Weekly log (zk)",
      },
      -- stylua: ignore start
      { "<leader>zm", function() require("zk").new({ title = "Quick Notes" }) end, desc = "Quick notes (zk)" },
      { "<leader>zd", function() require("zk").new({ dir = "daily" }) end, desc = "Daily note (zk)" },
      --stylua: ignore end
      { "<leader>zl", "<cmd>ZkLinks<CR>", desc = "zk Links" },
      { "<leader>zb", "<cmd>ZkBacklinks<CR>", desc = "zk Backlinks" },
    },
  },
  {
    "jakewvincent/mkdnflow.nvim",
    opts = {
      modules = {
        bib = false,
        buffers = false, -- Disable navigation with Backspace and Del - Use C-I and C-O
        conceal = false,
        cursor = true,
        folds = false, -- Use default vim folding
        foldtext = true,
        lists = true,
        links = true, -- Using zk for that (might want to enable for citations and mapping at some point)
        maps = true,
        paths = false,
        tables = true,
        yaml = false,
        cmp = false,
      },
      mappings = {
        MkdnNextLink = { "n", "]l" },
        MkdnPrevLink = { "n", "[l" },
        -- Replaced with MkdnNewListItem because tables
        -- https://github.com/jakewvincent/mkdnflow.nvim/issues/263
        MkdnEnter = false,
        MkdnNewListItem = { "i", "<CR>" },
        MkdnDecreaseHeading = { "n", "=" }, -- Default "-" conflicts with oil.nvim
        MkdnCreateLinkFromClipboard = false,
      },
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- whatever backend you would like to use
      max_width = 100,
      max_height = 20,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
    opts = {
      default = {
        prompt_for_file_name = false,
      },
      filetypes = {
        tex = {
          template = [[
\includegraphics[width=0.8\textwidth]{$FILE_PATH}
    ]],
        },
      }
    },
    keys = {
      { "<leader>zp", "<Cmd>PasteImage<CR>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    ft = { "markdown" },
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdowPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>zv",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    init = function()
      vim.g.mkdp_auto_close = false
      vim.g.mkdp_combine_preview = true
    end,
    config = function()
      -- TODO: Lua function?
      vim.cmd([[
        function OpenMarkdownPreview (url)
        execute "silent ! firefox --new-window " . a:url
        endfunction
]])
      vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
      -- Copied from lazyvim
      vim.cmd([[do FileType]])
    end,
  },
}
