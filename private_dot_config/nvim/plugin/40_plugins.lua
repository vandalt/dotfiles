-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Useful plugins ============================================================
add({ "https://github.com/nvim-lua/plenary.nvim" })
now_if_args(function()
  add({ "https://github.com/mason-org/mason.nvim" })
  require("mason").setup()
end)

-- Tree-sitter ================================================================
now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd("TSUpdate") end
  Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  })

  -- Define languages which will have parsers installed and auto enabled
  -- After changing this, restart Neovim once to install necessary parsers. Wait
  -- for the installation to finish before opening a file for added language(s).
  local languages = {
    "bash",
    "c",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "ninja",
    "printf",
    "python",
    "query",
    "regex",
    "rst",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  }
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
end)

-- Language servers ===========================================================
now_if_args(function()
  add({ "https://github.com/neovim/nvim-lspconfig" })

  vim.lsp.enable({
    "lua_ls",
    "basedpyright",
    "ruff",
  })
end)

-- Formatting =================================================================
later(function()
  add({ "https://github.com/stevearc/conform.nvim" })

  require("conform").setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = "fallback",
    },
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    formatters_by_ft = { lua = { "stylua" } },
  })
end)

-- Snippets ===================================================================
later(function() add({ "https://github.com/rafamadriz/friendly-snippets" }) end)

-- Chezmoi ====================================================================
now(function()
  add({ "https://github.com/alker0/chezmoi.vim" })
  vim.g["chezmoi#source_dir_path"] = vim.env.HOME .. "/.local/share/chezmoi"
  vim.g["chezmoi#use_tmp_buffer"] = 1
end)

now_if_args(function()
  add({ "https://github.com/xvzc/chezmoi.nvim" })
  require("chezmoi").setup({})
  Config.new_autocmd(
    { "BufRead", "BufNewFile" },
    { vim.env.HOME .. "/.local/share/chezmoi/*" },
    function() vim.schedule(require("chezmoi.commands.__edit").watch) end,
    "Open with chezmoi"
  )
end)

-- Markdown ===================================================================
now_if_args(function()
  add({ "https://github.com/zk-org/zk-nvim" })
  require("zk").setup({
    picker = "minipick",
  })
end)

now_if_args(function()
  add({ "https://github.com/jakewvincent/mkdnflow.nvim" })
  require("mkdnflow").setup({
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
  })
end)

-- Python REPL ================================================================
now_if_args(function()
  vim.cmd.packadd("jupytext.nvim")
  require("jupytext").setup({
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  })
end)
