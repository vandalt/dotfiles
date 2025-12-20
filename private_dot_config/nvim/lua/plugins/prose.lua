local markdownlint_cli2_args = { "--config", vim.env.HOME .. "/.config/markdownlint/config.markdownlint.yaml" }
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
  -- Linting
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = { ["markdownlint-cli2"] = { prepend_args = markdownlint_cli2_args } },
    },
  },

  -- Preview
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_auto_close = false
      vim.g.mkdp_combine_preview = true
    end,
  },

  -- Rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = { enabled = true, conceal_delimiters = false, language = true, border = "thin" },
      html = { comment = { conceal = false } },
    },
  },

  -- Paste images
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      default = { prompt_for_file_name = false, drag_and_drop = { enabled = false } },
    },
  },

  -- Zk
  {
    "zk-org/zk-nvim",
    dev = true,
    main = "zk",
    cmd = { "ZkNotes", "ZkNew", "ZkLinks", "ZkBacklincks" },
    opts = {
      picker = "snacks_picker",
    },
    keys = {
      { "<leader>zd", function() require("zk").new({ dir = "daily" }) end, desc = "Daily note (zk)" },
      { "<leader>zo", function() require("zk").edit() end, desc = "Open note (zk)" },
      {
        "<leader>zn",
        function() require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" }) end,
        desc = "New Note (zk)",
      },
      {
        "<leader>zn",
        ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<CR>",
        mode = { "x" },
        desc = "New note from title selection",
      },
      {
        "<leader>zc",
        ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: '), dir = 'zettel' }<CR>",
        mode = { "x" },
        desc = "New note from content selection",
      },
      {
        "<leader>zw",
        function() require("zk").new({ dir = "weekly", date = get_date_zw(zk_start_week) }) end,
        desc = "Weekly log (zk)",
      },
    },
  },

  -- Disable marksman LSP when in a zk workspace
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          enabled = vim.fn.finddir(".zk", ".;") == "",
        },
      },
    },
  },

  -- vimtex
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_compiler_method = "tectonic"
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
    end,
  },

  { "barreiroleo/ltex-extra.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex_plus = {
          ---@diagnostic disable-next-line: unused-local
          on_attach = function(client, bufnr)
            require("ltex_extra").setup({
              load_langs = { "en-US", "fr" },
              path = vim.fn.expand("~") .. "/.local/share/ltex",
            })
          end,
        },
      },
    },
  },
}
