local add = vim.pack.add
local later = require("util.config").later

-- Colorscheme =================
add({ "https://github.com/rebelot/kanagawa.nvim" })
require("kanagawa").setup({
  background = {
    dark = "dragon",
    light = "lotus",
  },
})
vim.cmd("colorscheme kanagawa")

-- Basic plugins ===================================================================
vim.cmd([[packadd nvim.undotree]])
require("mini.surround").setup() -- Surround with sa/sd/sr
require("mini.splitjoin").setup() -- gS to split and join
later(function() require("mini.extra").setup() end) -- Misc extra functionality
add({ "https://github.com/justinmk/vim-gtfo" })
add({ "https://github.com/KenN7/vim-arsync", "https://github.com/prabirshrestha/async.vim" })
add({ "https://github.com/tpope/vim-eunuch" })

-- persistence.nvim (sessions) ===========
add({ "https://github.com/folke/persistence.nvim" })
require("persistence").setup()

-- Autopair ===============================================================================================
require("mini.pairs").setup({
  mappings = {
    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = '[^\\"].', register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%aç\\'].", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
  },
})
local map_tex = function() MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" }) end
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = { "tex", "plaintex" }, callback = map_tex, desc = "Map $ pair in tex" }
)
vim.g.minipairs_disable = true

-- mini.ai ==========================================================================
-- Custom textobjects with "a" and "i"
later(function()
  local ai = require("mini.ai")
  require("mini.ai").setup({
    n_lines = 300,
    custom_textobjects = {
      j = require("util").combined_cell_spec,
      o = ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      u = ai.gen_spec.function_call(),
      h = ai.gen_spec.treesitter({ a = "@section.outer", i = "@section.inner" }),
    },
  })
end)

-- mini.pick ======================================================================================
require("mini.pick").setup({
  mappings = {
    choose_alt = { char = "<C-y>", func = function() vim.api.nvim_input("<CR>") end },
    choose_marked_alt = { char = "<C-S-y>", func = function() vim.api.nvim_input("<M-CR>") end },
  },
})
-- Customize ui_select to show item indices
later(function() vim.ui.select = require("util").minipick_select_idx end)
