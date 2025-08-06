local add = require("mini.deps").add

add("mason-org/mason.nvim")
require("mason").setup()

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "main",
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end,
  },
})
local parsers = {
  "diff",
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
require("nvim-treesitter").install(parsers)
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
vim.api.nvim_create_autocmd("FileType", {
  pattern = all_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

-- Using PR branch for now: https://github.com/folke/lazydev.nvim/pull/106
add({ source = "Jari27/lazydev.nvim", checkout = "deprecate_client_notify" })
require("lazydev").setup({ integrations = { cmp = false } })

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

add({
  source = "CopilotC-Nvim/CopilotChat.nvim",
  depends = { "nvim-lua/plenary.nvim", "zbirenbaum/copilot.lua" },
})
require("CopilotChat").setup({ headers = { user = "vandalt" }, auto_insert_mode = true })

add("GCBallesteros/jupytext.nvim")
require("jupytext").setup({ style = "markdown", output_extension = "md", force_ft = "markdown" })

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
  adapters = { require("neotest-python") },
})

add("stevearc/conform.nvim")
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
  default_format_opts = { lsp_format = "fallback" },
})

vim.cmd([[packadd toggleterm.nvim]])
-- add("akinsho/NotebookNavigator.nvim")
require("toggleterm").setup({
  size = function() return 0.30 * vim.o.lines end,
  persist_size = false,
  open_mapping = [[<C-/>]],
  responsiveness = { horizontal_breakpoint = 200 },
  shade_terminals = false,
  persist_mode = false,
})

-- Jupyter notebooks
vim.cmd([[packadd NotebookNavigator.nvim]])
-- add("GCBallesteros/NotebookNavigator.nvim")
require("notebook-navigator").setup()
