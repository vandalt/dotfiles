local add, later = require("mini.deps").add, require("mini.deps").later

-- Misc useful plugins =================================================================================================
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

add({
  source = "CopilotC-Nvim/CopilotChat.nvim",
  depends = { "nvim-lua/plenary.nvim", "zbirenbaum/copilot.lua" },
})
require("CopilotChat").setup({ headers = { user = "vandalt" }, auto_insert_mode = true })

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

add("folke/persistence.nvim")
require("persistence").setup()

add("folke/tokyonight.nvim")

-- Needs to be a 'start' plugin, either add directly from init.lua or move to 'start' subdir with
-- mv ~/.local/share/nvim/site/pack/deps/opt/chezmoi.vim/ ~/.local/share/nvim/site/pack/deps/start/
vim.g["chezmoi#use_tmp_buffer"] = 1
add("alker0/chezmoi.vim")

add("xvzc/chezmoi.nvim")
require("chezmoi").setup({})

-- LSP, snippets and linting and formatting ============================================================================
add("mason-org/mason.nvim")
require("mason").setup()

add("folke/lazydev.nvim")
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

-- Debugging and testing ===============================================================================================
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

local neotest_local = true
if not neotest_local then
  add({
    source = "nvim-neotest/neotest",
    depends = { "nvim-lua/plenary.nvim", "nvim-neotest/nvim-nio", "nvim-neotest/neotest-python" },
  })
else
  vim.cmd[[packadd neotest]]
  vim.cmd[[packadd neotest-python]]
  add({
    source = "nvim-neotest/nvim-nio",
    depends = { "nvim-lua/plenary.nvim",  },
  })
end
---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
  adapters = { require("neotest-python")({ dap = { justMyCode = false }, pytest_discover_instances = false }) },
})
--
-- Jupyter notebooks and REPL ==========================================================================================
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

-- Markdown and notes ==================================================================================================
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
require("img-clip").setup()
