-- vim: foldmethod=marker
local add, later = require("mini.deps").add, require("mini.deps").later

-- {{{ Misc useful plugins =============================================================================================
vim.cmd([[packadd nvim.undotree]])
add("stevearc/oil.nvim")
require("oil").setup({
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-a>"] = { "actions.select", opts = { horizontal = true } },
  },
})

vim.cmd([[packadd toggleterm.nvim]])
-- add("akinsho/toggleterm.nvim")
require("toggleterm").setup({
  size = function() return 0.30 * vim.o.lines end,
  persist_size = false,
  open_mapping = [[<C-/>]],
  responsiveness = { horizontal_breakpoint = 200 },
  shade_terminals = false,
  persist_mode = false,
})

add("folke/sidekick.nvim")
require("sidekick").setup()

add("lukas-reineke/indent-blankline.nvim")
-- Use mini.indentscope for the scope
require("ibl").setup({ scope = { enabled = false } })

add({
  source = "kenn7/vim-arsync",
  depends = { "prabirshrestha/async.vim" },
})
add("justinmk/vim-gtfo")

add("folke/flash.nvim")
require("flash").setup({ modes = { char = { enabled = false } } })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function() vim.keymap.set("n", "<CR>", "<CR>", { buffer = true }) end,
})

add("folke/persistence.nvim")
require("persistence").setup()

add("folke/tokyonight.nvim")

-- Needs to be a 'start' plugin, either add directly from init.lua or move to 'start' subdir with
-- mv ~/.local/share/nvim/site/pack/deps/opt/chezmoi.vim/ ~/.local/share/nvim/site/pack/deps/start/
vim.g["chezmoi#use_tmp_buffer"] = 1
add("alker0/chezmoi.vim")

add("xvzc/chezmoi.nvim")
require("chezmoi").setup({})

add({ source = "myakove/f-string-toggle.nvim", checkout = "fix/replace-deprecated-ts-utils" })
require("f-string-toggle").setup({ key_binding = false })
-- }}}

-- {{{ LSP, snippets and linting and formatting ========================================================================
add("mason-org/mason.nvim")
require("mason").setup()

add("folke/lazydev.nvim")
require("lazydev").setup({
  integrations = { cmp = false },
  library = { { path = "snacks.nvim", words = { "Snacks" } } },
})

add("j-hui/fidget.nvim")
require("fidget").setup({})

add("neovim/nvim-lspconfig")
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
})
vim.lsp.enable({ "lua_ls", "basedpyright", "ruff" })

add("rafamadriz/friendly-snippets")
add("danymat/neogen")
require("neogen").setup({
  snippet_engine = "mini",
  languages = { python = { template = { annotation_convention = "reST" } } },
})

add("stevearc/conform.nvim")
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
  default_format_opts = { lsp_format = "fallback" },
})
-- }}}

-- {{{ Treesitter ======================================================================================================
add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "main",
  monitor = "main",
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end,
  },
})
add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main", monitor = "main" })
local parsers = {
  "c",
  "cpp",
  "bibtex",
  "diff",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "rst",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}
local filetype_seen = {}
local all_filetypes = {}
for _, parser in ipairs(parsers) do
  local parser_fts = vim.treesitter.language.get_filetypes(parser)
  for _, ft in ipairs(parser_fts) do
    if not filetype_seen[ft] then
      all_filetypes[#all_filetypes + 1] = ft
      filetype_seen[ft] = true
    end
  end
end

require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
  pattern = all_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = false, lookbehind = false, include_surrounding_whitespace = false },
})
-- }}}

-- {{{ Debugging and testing ===========================================================================================
add({ source = "mfussenegger/nvim-dap", depends = { "jbyuki/one-small-step-for-vimkind" } })
local dap = require("dap")
dap.configurations.lua = { {
  type = "nlua",
  request = "attach",
  name = "Attach to running Neovim instance",
} }
dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

add("mfussenegger/nvim-dap-python")
require("dap-python").setup(vim.env.MASON .. "/packages/debugpy/venv/bin/python")
require("dap-python").test_runner = "pytest"

add({
  source = "nvim-neotest/neotest",
  depends = { "nvim-lua/plenary.nvim", "nvim-neotest/nvim-nio", "nvim-neotest/neotest-python" },
})
---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
  adapters = { require("neotest-python")({ dap = { justMyCode = false }, pytest_discover_instances = false }) },
  -- Override some of the highlight groups that look bad with the light theme
  -- TODO: Remove or uncomment depending on what happens with PR: https://github.com/nvim-neotest/neotest/pull/553
  -- highlights = {
  --   passed = "DiagnosticOk",
  --   running = "DiagnosticWarn",
  --   skipped = "DiagnosticInfo",
  --   file = "DiagnosticInfo",
  --   dir = "DiagnosticInfo",
  --   select_win = "Title",
  --   watching = "DiagnosticWarn",
  -- }
})
-- }}}

-- {{{ Jupyter notebooks and REPL ======================================================================================
vim.cmd([[packadd jupytext.nvim]])
-- add("GCBallesteros/jupytext.nvim")
require("jupytext").setup({ style = "markdown", output_extension = "md", force_ft = "markdown" })

-- Jupyter notebooks
vim.cmd([[packadd NotebookNavigator.nvim]])
-- add("GCBallesteros/NotebookNavigator.nvim")
require("notebook-navigator").setup()

vim.cmd([[packadd otter.nvim]])
-- add("jmbuhr/otter.nvim")

add("quarto-dev/quarto-nvim")
require("quarto").setup({
  lspFeatures = { enabled = true, chunks = "all" },
  codeRunner = {
    enabled = true,
    default_method = function(cell, _)
      local text_lines = require("quarto.tools").concat(cell.text)
      local id = 1
      local use_bracketed_paste = true
      require("toggleterm").exec(text_lines, id, nil, nil, nil, nil, nil, nil, use_bracketed_paste)
    end,
  },
})
-- }}}

-- {{{ Markdown and notes ==============================================================================================
add({
  source = "iamcco/markdown-preview.nvim",
  hooks = {
    post_install = later(function() vim.fn["mkdp#util#install"]() end),
    post_checkout = function() vim.fn["mkdp#util#install"]() end,
  },
})
vim.g.mkdp_auto_close = false
vim.g.mkdp_combine_preview = true

add("zk-org/zk-nvim")
require("zk").setup({
  picker = "minipick",
})

add("HakonHarnes/img-clip.nvim")
require("img-clip").setup({
  -- Drag and drop causes warning when pasting in cmd mode
  default = { prompt_for_file_name = false, drag_and_drop = { enabled = false } },
})
-- add("3rd/image.nvim")
--@diagnostic disable-next-line: missing-fields
-- require("image").setup({
--   processor = "magick_cli",
--   window_overleaf
-- })
add("folke/snacks.nvim")
require("snacks").setup({
  image = {
    enabled = true,
  },
})
-- }}}
