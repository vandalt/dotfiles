local add = vim.pack.add
local later = Config.later

-- AI sidekick.nvim =========
add({ "https://github.com/folke/sidekick.nvim" })
require("sidekick").setup()

-- f-string-toggle.nvim =================================
add({ "https://github.com/roobert/f-string-toggle.nvim" })
require("f-string-toggle").setup({ key_binding = false })

-- Snippets ==========================================================================================================
local gen_loader = require("mini.snippets").gen_loader -- Load snippets from collection (e.g. friendly-snippets)
require("mini.snippets").setup({
  snippets = { gen_loader.from_lang({ lang_patterns = { markdown_inline = { "markdown.json" } } }) },
})
-- Without this "fake" LSP, mini.snippets won't show up in mini.completion
-- Only actual LSP snippets will and mini.snippets need to be manually expanded with "name<c-j>"
later(require("mini.snippets").start_lsp_server)

-- Completion for LSP and fallback (buffer text) ===================================================================
-- For other things (paths), use default vim completion
-- Stolen from https://github.com/echasnovski/nvim/blob/b098c1b83d1715b7e980d1588b1491fe7d0393a4/plugin/20_mini.lua#L219
-- Make sure snippets show on top and disable text completion (use <C-x><C-n> for that)
local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base) return MiniCompletion.default_process_items(items, base, process_items_opts) end
require("mini.completion").setup({
  delay = { completion = 10 ^ 7 },
  lsp_completion = { source_func = "omnifunc", auto_setup = false, process_items = process_items },
})
local on_attach = function(args) vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end
vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })
vim.lsp.config("*", {
  capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    MiniCompletion.get_lsp_capabilities()
  ),
})

-- LSP, snippets and linting and formatting ========================================================================
add({ "https://github.com/mason-org/mason.nvim" })
require("mason").setup()

add({ "https://github.com/neovim/nvim-lspconfig" })

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

add({ "https://github.com/folke/lazydev.nvim" })
require("lazydev").setup()

add({ "https://github.com/rafamadriz/friendly-snippets" })
add({ "https://github.com/danymat/neogen" })
require("neogen").setup({
  snippet_engine = "mini",
  languages = { python = { template = { annotation_convention = "reST" } } },
})

add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
  default_format_opts = { lsp_format = "fallback" },
})

-- Treesitter ======================================================================================================
Config.on_packchanged("nvim-treesitter", { "update" }, function() vim.cmd("TSUpdate") end, ":TSUpdate")
add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})
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

-- Debugging and testing ===========================================================================================
add({ "https://github.com/mfussenegger/nvim-dap", "https://github.com/jbyuki/one-small-step-for-vimkind" })
local dap = require("dap")
dap.configurations.lua = { {
  type = "nlua",
  request = "attach",
  name = "Attach to running Neovim instance",
} }
dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

add({ "https://github.com/mfussenegger/nvim-dap-python" })
require("dap-python").setup(vim.env.MASON .. "/packages/debugpy/venv/bin/python")
require("dap-python").test_runner = "pytest"

add({
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-neotest/neotest-python",
})
---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
  adapters = { require("neotest-python")({ dap = { justMyCode = false }, pytest_discover_instances = false }) },
  -- Override some of the highlight groups that look bad with the light theme
  -- Temporary fix for default colorscheme, see https://github.com/nvim-neotest/neotest/pull/553
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

-- Jupyter notebooks and REPL ======================================================================================
vim.cmd([[packadd jupytext.nvim]])
-- add("GCBallesteros/jupytext.nvim")
require("jupytext").setup({ style = "markdown", output_extension = "md", force_ft = "markdown" })

-- Jupyter notebooks
vim.cmd([[packadd NotebookNavigator.nvim]])
-- add("GCBallesteros/NotebookNavigator.nvim")
require("notebook-navigator").setup()

-- vim.cmd([[packadd otter.nvim]])
add({ "https://github.com/jmbuhr/otter.nvim" })

add({ "https://github.com/quarto-dev/quarto-nvim" })
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
