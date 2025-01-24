return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
        config = function()
          -- require('telescope').load_extension('fzf')
        end
      },
    },
    cmd = "Telescope",
    -- TODO: Try ivy theme (https://github.com/nvim-telescope/telescope.nvim/issues/848)
    config = function()
      require("telescope").setup({})
      pcall(require('telescope').load_extension, 'fzf')
    end,
    keys = {
      -- TODO: Add chezmoi and replace fc to search chezmoi config
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>sg", "<Cmd>Telescope live_grep<CR>", desc = "Search grep" },
      { "<leader>sh", "<Cmd>Telescope help_tags<CR>", desc = "Search help pages" },
      { "<leader>sk", "<Cmd>Telescope keymaps<CR>", desc = "Search keymaps" },
      { "<leader>gs", "<Cmd>Telescope git_status<CR>", desc = "Telescope Git status" },
    },
  },
}
