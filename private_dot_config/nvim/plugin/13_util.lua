local add = vim.pack.add

-- persistence.nvim (sessions) ===========
add({"https://github.com/folke/persistence.nvim"})
require("persistence").setup()

-- chezmoi plugins ================================================================================
-- Needs to be a 'start' plugin, either add directly from init.lua or move to 'start' subdir with
-- mv ~/.local/share/nvim/site/pack/deps/opt/chezmoi.vim/ ~/.local/share/nvim/site/pack/deps/start/
vim.g["chezmoi#use_tmp_buffer"] = 1
add({"https://github.com/alker0/chezmoi.vim"})

-- add("xvzc/chezmoi.nvim")
vim.cmd([[packadd chezmoi.nvim]])
require("chezmoi").setup({})
