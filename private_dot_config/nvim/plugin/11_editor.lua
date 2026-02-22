local add = vim.pack.add
local later = Config.later

-- Git plugins (diff, command and statusline) ======================================================================
require("mini.diff").setup({ view = { style = "number" } }) -- Diff in sidebar

-- Git commands and info for statusline
require("mini.git").setup()
-- Define extra highlight groups once before the autocmd
vim.api.nvim_set_hl(0, "GitBlameHashRoot", { link = "Tag" })
vim.api.nvim_set_hl(0, "GitBlameHash", { link = "Identifier" })
vim.api.nvim_set_hl(0, "GitBlameAuthor", { link = "String" })
vim.api.nvim_set_hl(0, "GitBlameDate", { link = "Comment" })
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitCommandSplit",
  desc = "Autocmd to keep vertical git blame aligned with the buffer",
  callback = require("util").git_blame_autocmd,
})

-- mini.notify ==============================================================================================
local predicate = function(notif)
  local skip_clients = { lua_ls = true, basedpyright = true }
  if not (notif.data.source == "lsp_progress" and skip_clients[notif.data.client_name]) then
    return true
  end
  -- Filter out some LSP progress notifications from 'lua_ls' and basedpyright
  if notif.data.client_name == "lua_ls" then
    return notif.msg:find("Diagnosing") == nil and notif.msg:find("semantic tokens") == nil
  else
    return false
  end
end
local custom_sort = function(notif_arr) return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr)) end
require("mini.notify").setup({ content = { sort = custom_sort } })

-- mini.hipatterns =================================================================================================
-- Highlight stuff
-- (uses notebook-navigator so need to run in later())
later(function()
  local function word(mystr) return "%f[%w]()" .. mystr .. "()%f[%W]" end
  require("mini.hipatterns").setup({
    highlighters = {
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      fixme = { pattern = word("FIXME"), group = "MiniHipatternsFixme" },
      bug = { pattern = word("BUG"), group = "MiniHipatternsFixme" },
      hack = { pattern = word("HACK"), group = "MiniHipatternsHack" },
      todo = { pattern = word("TODO"), group = "MiniHipatternsTodo" },
      note = { pattern = word("NOTE"), group = "MiniHipatternsNote" },
      cells = require("notebook-navigator").minihipatterns_spec,
    },
  })
end)

-- UI plugins (statusline, icons, indent guides) ===================================================================
require("mini.statusline").setup()

-- Icons, with recommended tweaks
require("mini.icons").setup()
later(MiniIcons.mock_nvim_web_devicons)
later(MiniIcons.tweak_lsp_kind)

-- Static indent guides
add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
require("ibl").setup({ scope = { enabled = false } })

-- Indent scope highlight
require("mini.indentscope").setup({
  draw = { animation = require("mini.indentscope").gen_animation.none() },
  options = {
    try_as_border = true, -- Check if current line is border (e.g. function name)
    border = "top", -- Don't mark empty lines at the end of a scope
  },
  symbol = "▎",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "oil_preview", "toggleterm", "sidekick_terminal" },
  callback = function() vim.b.miniindentscope_disable = true end,
  desc = "Disable indentscope in some filetypes",
})

-- oil.nvim ========================================================================================================
add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-a>"] = { "actions.select", opts = { horizontal = true } },
  },
})

-- Toggleterm ======================================================================================================
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

-- flash.nvim ======================================================================================================
add({ "https://github.com/folke/flash.nvim" })
require("flash").setup({ modes = { char = { enabled = false } } })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function() vim.keymap.set("n", "<CR>", "<CR>", { buffer = true }) end,
})

-- Markdown and notes ==============================================================================================
Config.on_packchanged(
  "markdown-preview",
  { "install", "update" },
  function() vim.fn["mkdp#util#install"]() end,
  "install markdow-npreview"
)
add({ "https://github.com/iamcco/markdown-preview.nvim" })
vim.g.mkdp_auto_close = false
vim.g.mkdp_combine_preview = true

add({ "https://github.com/zk-org/zk-nvim" })
require("zk").setup({
  picker = "minipick",
})

add({ "https://github.com/HakonHarnes/img-clip.nvim" })
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
add({ "https://github.com/folke/snacks.nvim" })
require("snacks").setup({
  image = {
    enabled = true,
  },
})

-- mini.clue =======================================================================================================
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
    { mode = "n", keys = "<leader>i", desc = "+image" },
    { mode = "n", keys = "<leader>j", desc = "+jupyter" },
    { mode = "n", keys = "<leader>m", desc = "+markdown/mini" },
    { mode = "n", keys = "<leader>n", desc = "+notify" },
    { mode = "n", keys = "<leader>v", desc = "+vim.pack" },
    { mode = "n", keys = "<leader>vp", desc = "+vim.pack" },
    { mode = "n", keys = "<leader>r", desc = "+rsync/run" },
    { mode = "n", keys = "<leader>s", desc = "+search/session" },
    { mode = "n", keys = "<leader>t", desc = "+tests" },
    { mode = "n", keys = "<leader>u", desc = "+toggle" },
    { mode = "n", keys = "<leader>z", desc = "+zk" },
  },
})
