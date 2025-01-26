return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>b", group = "buffers" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "find" },
          { "<leader>g", group = "git" },
          { "<leader>r", group = "reload" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "toggle" },
          { "<leader>e", group = "explore" },
          { "<leader>q", group = "session" },
          { "<localLeader>l", group = "vimtex" },
          { "g", group = "goto/capitalize" },
          { "gc", group = "comment" },
          { "gr", group = "incremental" },
          { "gs", group = "surround" },
        },
      },
      icons = {
        rules = {
          { plugin = "oil.nvim", cat = "filetype", name = "oil" },
          { pattern = "explore", cat = "filetype", name = "oil" },
          { pattern = "vimtex", cat = "filetype", name = "tex" },
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    event = "VimEnter",
    ---@module 'oil'
    ---@type oil.SetupOpts
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
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {},
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>ud", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      { "<leader>sr", "<Cmd>GrugFar<CR>", desc = "Search and replace (grug-far)" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (cwd)" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
      { "<leader>ql", function() require("persistence").load({last=true}) end, desc = "Restore last session (anywhere)" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },
}
