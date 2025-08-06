local later = require("mini.deps").later

-- Required even when default so hipatterns look good
vim.cmd("colorscheme default")

require("mini.surround").setup()
local gen_spec = require("mini.ai").gen_spec
require("mini.ai").setup({
  custom_textobjects = {
    u = gen_spec.function_call(),
    f = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
  },
})

require("mini.icons").setup()
later(MiniIcons.mock_nvim_web_devicons)
later(MiniIcons.tweak_lsp_kind)

require("mini.statusline").setup()

-- gS to split and join
require("mini.splitjoin").setup()

-- Highlight stuff
require("mini.hipatterns").setup({
  highlighters = {
    fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
    hack = { pattern = "HACK", group = "MiniHipatternsHack" },
    todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
    note = { pattern = "NOTE", group = "MiniHipatternsNote" },
  },
})

-- Load snippets from collection (e.g. friendly-snippets)
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = { gen_loader.from_lang() },
})
-- Without this "fake" LSP, mini.snippets won't show up in mini.completion
-- Only actual LSP snippets will and mini.snippets need to be manually expanded with "name<c-j>"
later(require("mini.snippets").start_lsp_server)

-- Git commands and info for statusline
require("mini.git").setup()

-- Diff in sidebar
require("mini.diff").setup({ view = { style = "number" } })

-- Save and load sessions
require("mini.sessions").setup()

-- Picker
require("mini.pick").setup({
  mappings = {
    choose_alt = { char = "<C-y>", func = function() vim.api.nvim_input("<CR>") end },
    choose_marked_alt = { char = "<C-S-y>", func = function() vim.api.nvim_input("<M-CR>") end },
  },
})

-- Completion for LSP and fallback (buffer text)
-- For other things (paths) use default vim completion
require("mini.completion").setup({
  lsp_completion = { source_func = "omnifunc", auto_setup = false },
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
