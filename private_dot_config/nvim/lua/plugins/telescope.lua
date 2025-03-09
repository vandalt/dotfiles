return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      },
      "nvim-telescope/telescope-symbols.nvim",
    },
    cmd = "Telescope",
    config = function()
      local open_with_trouble = require("trouble.sources.telescope").open
      local defaults = {
        mappings = {
          i = { ["<c-t>"] = open_with_trouble },
          n = { ["<c-t>"] = open_with_trouble },
        }
      }
      local ivy_defaults = require("telescope.themes").get_ivy()
      defaults = vim.tbl_deep_extend("keep", defaults, ivy_defaults)
      require("telescope").setup({
        defaults = defaults,
      })
      pcall(require('telescope').load_extension, 'fzf')
    end,
    keys = {
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<Cmd>Telescope git_files<CR>", desc = "Find git files" },
      { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>se", function() require("telescope.builtin").symbols({ sources = {"emoji"}}) end, desc = "Search emoji" },
      { "<leader>si", function() require("telescope.builtin").symbols() end, desc = "Search icons" },
      { "<leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Search LSP symbols" },
      { "<leader>st", "<Cmd>TodoTelescope<CR>", desc = "Search TODO comments" },
      { "<leader>sg", "<Cmd>Telescope live_grep<CR>", desc = "Search grep" },
      { "<leader>sh", "<Cmd>Telescope help_tags<CR>", desc = "Search help pages" },
      { "<leader>sk", "<Cmd>Telescope keymaps<CR>", desc = "Search keymaps" },
      { "<leader>gs", "<Cmd>Telescope git_status<CR>", desc = "Telescope Git status" },
    },
  },
}
