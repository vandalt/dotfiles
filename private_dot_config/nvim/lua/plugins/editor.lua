return {
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
  {
    "which-key.nvim",
    opts = {
      preset = "helix",  -- classic, modern, helix
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>r", "rsync" },
          { "<leader>z", "zk" },
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- NOTE: Required to open `nvim .` with oil...
    lazy = false,
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<leader>es"] = "actions.select_vsplit",
        ["<leader>eh"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = false,
        ["<leader>er"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
  },
  {
    "justinmk/vim-gtfo",
    dev = true,
    init = function()
      -- Open kitty in a new window
      vim.g["gtfo#terminals"] = { unix = "kitty" }
      vim.g["gtfo#kitty_integration"] = 0
    end,
  },
  -- Enhanced vim shell commands
  "tpope/vim-eunuch",
  -- Detect tabstop and shiftwidth
  "tpope/vim-sleuth",
  {
    "mbbill/undotree",
    keys = {
      { "<leader>uu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    opts = {
      close_if_last_window = true,
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
}
