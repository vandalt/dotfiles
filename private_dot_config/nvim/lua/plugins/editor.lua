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
    "folke/flash.nvim",
    opts = {
      -- When using regular search, don't auto-jump to labels, first enable them with ";"
      -- By placing this here, will not affect regular "s" jump
      modes = { search = { search = { trigger = ";" } } },
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
    init = function()
      vim.g["gtfo#terminals"] = { unix = "kitty" }
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
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      {
        "<leader>gky",
        function()
          require("gitlinker").link()
        end,
        mode = { "n", "v" },
        desc = "Git link yank",
      },
      {
        "<leader>gkb",
        function()
          require("gitlinker").link({ action = require("gitlinker.actions").system })
        end,
        mode = { "n", "v" },
        desc = "Git link browse",
      },
      {
        "<leader>gku",
        function()
          require("gitlinker").link({ remote = "upstream" })
        end,
        mode = { "n", "v" },
        desc = "Git link yank upstream",
      },
      {
        "<leader>gkU",
        function()
          require("gitlinker").link({ upstream = "upstream", action = require("gitlinker.actions").system })
        end,
        mode = { "n", "v" },
        desc = "Git link browse upstream",
      },
      {
        "<leader>gkc",
        function()
          require("gitlinker").link({ router_type = "current_branch" })
        end,
        mode = { "n", "v" },
        desc = "Git link yank current branch",
      },
      {
        "<leader>gkC",
        function()
          require("gitlinker").link({ router_type = "current_branch", action = require("gitlinker.actions").system })
        end,
        mode = { "n", "v" },
        desc = "Git link browse current branch",
      },
      {
        "<leader>gkb",
        function()
          require("gitlinker").link({ router_type = "default_branch" })
        end,
        mode = { "n", "v" },
        desc = "Git link yank default branch",
      },
      {
        "<leader>gkB",
        function()
          require("gitlinker").link({ router_type = "default_branch", action = require("gitlinker.actions").system })
        end,
        mode = { "n", "v" },
        desc = "Git link browse default branch",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    opts = {
      close_if_last_window = true,
    },
  },
  {
    "kmonad/kmonad-vim",
  },
  {
    "chrisbra/csv.vim",
    config = function()
      vim.g.csv_nomap_h = true
      vim.g.csv_nomap_l = true
    end,
  },
}
