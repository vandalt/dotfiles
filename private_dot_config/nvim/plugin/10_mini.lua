local later = require("mini.deps").later

require("mini.surround").setup()

require("mini.pairs").setup({
  mappings = {
    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = '[^\\"].', register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%aç\\'].", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
  },
})
local map_tex = function() MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" }) end
vim.api.nvim_create_autocmd("FileType", { pattern = { "tex", "plaintex" }, callback = map_tex })

require("mini.icons").setup()
later(MiniIcons.mock_nvim_web_devicons)
later(MiniIcons.tweak_lsp_kind)

require("mini.statusline").setup()

require("mini.indentscope").setup({ draw = { animation = require("mini.indentscope").gen_animation.none()}})

-- gS to split and join
require("mini.splitjoin").setup()

-- Load snippets from collection (e.g. friendly-snippets)
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = { gen_loader.from_lang({ lang_patterns = { markdown_inline = { "markdown.json" } } }) },
})
-- Without this "fake" LSP, mini.snippets won't show up in mini.completion
-- Only actual LSP snippets will and mini.snippets need to be manually expanded with "name<c-j>"
later(require("mini.snippets").start_lsp_server)

-- Git commands and info for statusline
require("mini.git").setup()

-- Diff in sidebar
require("mini.diff").setup({ view = { style = "number" } })

-- Picker
-- For built-in pickers, configure the tool directly (example ripgrep config file for smart case)
-- The ui.select stuff before and after is to preserve default for now.
local ui_select_orig = vim.ui.select
require("mini.pick").setup({
  mappings = {
    choose_alt = { char = "<C-y>", func = function() vim.api.nvim_input("<CR>") end },
    choose_marked_alt = { char = "<C-S-y>", func = function() vim.api.nvim_input("<M-CR>") end },
  },
})
vim.ui.select = ui_select_orig

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "n", keys = "<leader>a", desc = "+ai" },
    { mode = "n", keys = "<leader>b", desc = "+buffers" },
    { mode = "n", keys = "<leader>d", desc = "+debug" },
    { mode = "n", keys = "<leader>f", desc = "+find" },
    { mode = "n", keys = "<leader>g", desc = "+git" },
    { mode = "n", keys = "<leader>j", desc = "+jupyter" },
    { mode = "n", keys = "<leader>m", desc = "+markdown/mini" },
    { mode = "n", keys = "<leader>md", desc = "+mini.deps" },
    { mode = "n", keys = "<leader>i", desc = "+image" },
    { mode = "n", keys = "<leader>r", desc = "+rsync/run" },
    { mode = "n", keys = "<leader>s", desc = "+search/session" },
    { mode = "n", keys = "<leader>t", desc = "+tests" },
    { mode = "n", keys = "<leader>z", desc = "+zk" },
  },
})

-- Completion for LSP and fallback (buffer text)
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

-- Next two plugins use notebook-navigator so need to run later
later(function()
  -- Highlight stuff
  require("mini.hipatterns").setup({
    highlighters = {
      hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      bug = { pattern = "BUG", group = "MiniHipatternsFixme" },
      hack = { pattern = "HACK", group = "MiniHipatternsHack" },
      todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
      note = { pattern = "NOTE", group = "MiniHipatternsNote" },
      cells = require("notebook-navigator").minihipatterns_spec,
    },
  })

  -- Custom textobjects with "a" and "i"
  local ai = require("mini.ai")
  require("mini.ai").setup({
    n_lines = 300,
    custom_textobjects = {
      j = require("util").combined_cell_spec,
      o = ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      u = ai.gen_spec.function_call(),
    },
  })
end)

later(function() require("mini.extra").setup() end)
