-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Useful plugins ============================================================
now(function() add({ "https://github.com/nvim-lua/plenary.nvim" }) end)
now_if_args(function()
  add({ "https://github.com/mason-org/mason.nvim" })
  require("mason").setup()
end)
later(function() vim.cmd.packadd("nvim.undotree") end)
now_if_args(function()
  add({"https://github.com/folke/snacks.nvim"})
  require("snacks").setup({
    image = { enabled = true },
  })
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

  require("nvim-treesitter-textobjects").setup({})

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
  add({ "https://github.com/folke/lazydev.nvim" })

  vim.lsp.enable({
    "lua_ls",
    "basedpyright",
    "ruff",
  })

  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      { path = "mini.nvim", words = { "%f[%w]Mini[%u]" }},
    },
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
    formatters_by_ft = {
      lua = { "stylua" },
      snakemake = { "snakefmt" },
    },
  })
end)

-- Linting ====================================================================
later(function()
  add({ "https://github.com/mfussenegger/nvim-lint" })
  require("lint").linters_by_ft = {
    snakemake = { "snakemake" },
  }

  Config.new_autocmd("BufWritePost", nil, function() require("lint").try_lint() end, "Lint")
end)

-- Snippets ===================================================================
later(function() add({ "https://github.com/rafamadriz/friendly-snippets" }) end)

later(function()
  add({ "https://github.com/danymat/neogen"})
  require("neogen").setup({
    languages = { python = { template = { annotation_convention = "reST" } } },
    snippet_engine = "mini",
  })
end)

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

later(function()
  vim.cmd.packadd("toggleterm.nvim")
  require("toggleterm").setup({
    size = function() return 0.30 * vim.o.lines end,
    persist_size = false,
    open_mapping = nil,
    responsiveness = { horizontal_breakpoint = 200 },
    shade_terminals = false,
    persist_mode = false,
  })
  local Terminal = require("toggleterm.terminal").Terminal
  Config.lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    name = "lazygit",
    direction = "float",
  })
end)

later(function()
  vim.cmd.packadd("NotebookNavigator.nvim")
  require("notebook-navigator").setup({})
end)

later(function()
  add({ "https://github.com/jmbuhr/otter.nvim" })
  require("otter").setup({})

  add({ "https://github.com/quarto-dev/quarto-nvim" })
  require("quarto").setup({
    lspFeatures = { enabled = true, chunks = "all" },
    codeRunner = {
      enabled = true,
      default_method = function(cell, _)
        local text_lines = require("quarto.tools").concat(cell.text)
        local use_bracketed_paste = true
        require("toggleterm").exec(text_lines, nil, nil, nil, nil, nil, nil, nil, use_bracketed_paste)
      end,
    },
  })
end)

-- Sidekick ===================================================================
later(function()
  add({ "https://github.com/folke/sidekick.nvim" })
  require("sidekick").setup({})
end)

-- Snakemake ==================================================================
now_if_args(function()
  local name = "snakemake"
  add({ { src = "https://github.com/snakemake/snakemake", name = name } })
  local plugin = vim.pack.get({ name }, { info = false })[1]
  vim.opt.rtp:append(vim.fs.joinpath(plugin.path, "misc", "vim"))
end)

-- Testing =======================================================================
later(function()
  add({ "https://github.com/nvim-neotest/nvim-nio" })
  add({ "https://github.com/antoinemadec/FixCursorHold.nvim" })
  add({ "https://github.com/nvim-neotest/neotest" })
  add({ "https://github.com/nvim-neotest/neotest-python" })

  require("neotest").setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
    },
  })
end)

-- Debugging ==================================================================
later(function()
  add({ "https://codeberg.org/mfussenegger/nvim-dap.git" })
  add({ "https://github.com/nvim-neotest/nvim-nio" })
  add({ "https://github.com/rcarriga/nvim-dap-ui" })

  add({ "https://codeberg.org/mfussenegger/nvim-dap-python" })

  require("dapui").setup()
  require("dap-python").setup("debugpy-adapter")
end)
