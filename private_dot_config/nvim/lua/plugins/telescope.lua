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
    config = function()
      require("telescope").setup({
        defaults = require("telescope.themes").get_ivy()
      })
      pcall(require('telescope').load_extension, 'fzf')
    end,
    keys = {
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<Cmd>Telescope git_files<CR>", desc = "Find git files" },
      { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Search LSP symbols" },
      { "<leader>sg", "<Cmd>Telescope live_grep<CR>", desc = "Search grep" },
      { "<leader>sh", "<Cmd>Telescope help_tags<CR>", desc = "Search help pages" },
      { "<leader>sk", "<Cmd>Telescope keymaps<CR>", desc = "Search keymaps" },
      { "<leader>gs", "<Cmd>Telescope git_status<CR>", desc = "Telescope Git status" },
    },
  },
}
