return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "which-key.nvim",
    opts = {
      preset = "classic", -- classic, modern, helix
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>m", "markdown", icon = "󰍔" },
          { "<leader>r", "rsync", icon = "󰘿" },
          { "<leader>t", "persistence/splitjoin", icon = { icon = " ", color = "azure" } },
          { "<leader>z", "zk", icon = "󱓩" },
          { "<leader>i", group = "slime", icon = { icon = "" } },
          { "<leader>q", group = "quarto/quit", icon = "󰈙" },
        },
      },
      icons = {
        rules = {
          { pattern = "yank", icon = "󰅇", color = "yellow" },
          { pattern = "put", icon = "󰅇", color = "yellow" },
          { pattern = "clipboard", icon = "󰅇", color = "yellow" },
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    lazy = false, -- required to open `nvim .` with oil...
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<leader>es"] = { "actions.select", mode = "n", opts = { vertical = true } },
        ["<leader>eh"] = { "actions.select", mode = "n", opts = { horizontal = true } },
        ["<leader>er"] = { "actions.refresh", mode = "n" },
      },
    },
  },
  "justinmk/vim-gtfo",
  "tpope/vim-eunuch",
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
  },
  "kmonad/kmonad-vim",
  {
    "chrisbra/csv.vim",
    ft = "csv", -- Prevents warning in picker
    config = function()
      vim.g.csv_nomap_h = true
      vim.g.csv_nomap_l = true
    end,
  },
  {
    "KenN7/vim-arsync",
    dependencies = {
      "prabirshrestha/async.vim",
    },
    cmd = { "ARsyncUp", "ARsyncUpDelete", "ARsyncDown" },
    keys = {
      { "<leader>ru", "<cmd>ARsyncUp<CR>", desc = "Push with rsync" },
      { "<leader>rd", "<cmd>ARsyncUpDelete<CR>", desc = "Push with rsync and delete files" },
      { "<leader>rl", "<cmd>ARsyncDown<CR>", desc = "Pull with rsync" },
    },
  },
}
