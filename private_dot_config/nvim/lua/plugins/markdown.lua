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
        cmp = false
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
}
