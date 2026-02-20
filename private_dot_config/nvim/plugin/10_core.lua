local add = vim.pack.add

-- Colorscheme =================
add({"https://github.com/rebelot/kanagawa.nvim"})
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
-- TODO: Wrap in later? See minimax
require("mini.extra").setup() -- Misc extra functionality
add({"https://github.com/justinmk/vim-gtfo"})

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
local ai = require("mini.ai")
-- TODO: Later, see minimax
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


-- mini.pick ======================================================================================
require("mini.pick").setup({
  mappings = {
    choose_alt = { char = "<C-y>", func = function() vim.api.nvim_input("<CR>") end },
    choose_marked_alt = { char = "<C-S-y>", func = function() vim.api.nvim_input("<M-CR>") end },
  },
})
-- Customize ui_select to show item indices
-- TODO: Later?
vim.ui.select = require("util").minipick_select_idx
