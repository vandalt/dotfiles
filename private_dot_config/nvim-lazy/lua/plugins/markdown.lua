local markdownlint_cli2_args = { "--config", os.getenv("HOME") .. "/.config/markdownlint/config.markdownlint.yaml" }
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
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = markdownlint_cli2_args,
        },
        ["markdown-toc"] = {
          -- only execute if there is a <!-- toc --> comment
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["injected"] = {
          options = {
            lang_to_formatters = {
              -- Need to run ruff outside of LSP when in markdown code blocks
              python = {"ruff_format"}
            },
          }
        },
      },
      formatters_by_ft = {
        markdown = {
          "injected",
          "markdownlint-cli2",
          -- Has an annoying bug where it modifies frontmatter...
          -- Ref: https://github.com/jonschlinkert/markdown-toc/issues/151
          "markdown-toc",
        },
        quarto = {
          "injected",
          "markdownlint-cli2",
          -- Has an annoying bug where it modifies frontmatter...
          -- Ref: https://github.com/jonschlinkert/markdown-toc/issues/151
          "markdown-toc",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        quarto = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = { args = markdownlint_cli2_args },
      },
    },
  },
  {
    "zk-org/zk-nvim",
    dev = true,
    main = "zk",
    cmd = { "ZkNotes", "ZkIndex", "ZkNew" },
    opts = {
      picker = "snacks_picker",
      lsp = { auto_attach = { enabled = true } },
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
    enabled = true,
    dev = true,
    ft = { "markdown", "quarto" },
    opts = {
      modules = {
        bib = false, -- Parse bib files and follow citations
        buffers = false, -- Buffer forward and backward navigation (disabled: using C-I and C-O)
        conceal = false, -- Conceal wiki-links (disabled: using nvim's conceal)
        cursor = true, -- Jump to links and headings, yank anchor links
        folds = false, -- Custom folding (disabled: using nvim's folding)
        foldtext = true, -- Custom fold text with icons
        lists = true, -- Auto-add next bullet, toggle checkboxes
        links = true, -- Create, destroy and follow links
        maps = true, -- Set keymaps using the mappings table
        paths = false, -- Interpret and follow links (disabled: using zk lsp)
        tables = true, -- Format and navigate tables
        yaml = false, -- Parse YAML blocks (disabled: not using bib)
        cmp = false, -- Autocomplete links (disabled: using zk lsp)
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
      filetypes = {
        quarto = true,
        qmd = true,
        ipynb = true,
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
    opts = {
      default = {
        prompt_for_file_name = false,
      },
      filetypes = {
        tex = {
          template = [[
\begin{center}
  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
\end{center}
    ]],
        },
      },
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
