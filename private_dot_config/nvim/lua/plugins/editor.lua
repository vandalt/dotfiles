---@param direction string
local function trouble_move(direction)
  -- from Lazyvim
  if require("trouble").is_open() then
    require("trouble")[direction]({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd["c" .. direction])
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "ai" },
          { "<leader>b", group = "buffers" },
          { "<leader>c", group = "code" },
          { "<leader>e", group = "explore" },
          { "<leader>f", group = "find/fstring" },
          { "<leader>g", group = "git" },
          { "<leader>i", group = "ipython" },
          { "<leader>j", group = "jupyter" },
          { "<leader>n", group = "notifs" },
          { "<leader>q", group = "session/quarto" },
          { "<leader>r", group = "rsync" },
          { "<leader>s", group = "search" },
          { "<leader>x", group = "trouble/treesj" },
          { "<leader>t", group = "test" },
          { "<leader>u", group = "toggle" },
          { "<leader>w", group = "windows" },
          { "<leader>z", group = "zk/markdown", icon = "󱓩" },
          { "<localLeader>l", group = "vimtex" },
          { "g", group = "goto/capitalize" },
          { "gc", group = "comment" },
          { "gr", group = "incremental" },
          { "s", group = "surround" },
        },
      },
      triggers = {
        -- This causes issue with double-escape in terminal
        -- { "<auto>", mode = "nixsotc" },
        { "<auto>", mode = "nxso" },
        { "s", mode = { "n", "v" } },
      },
      icons = {
        rules = {
          { plugin = "copilot.lua", icon = " ", color = "orange" },
          { pattern = "explore", cat = "filetype", name = "oil" },
          { pattern = "trouble", cat = "filetype", name = "trouble" },
          { plugin = "oil.nvim", cat = "filetype", name = "oil" },
          { pattern = "vimtex", cat = "filetype", name = "tex" },
          { pattern = "yank", icon = "󰅇", color = "yellow" },
          { pattern = "put", icon = "󰅇", color = "yellow" },
          { pattern = "clipboard", icon = "󰅇", color = "yellow" },
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    enabled = true,
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
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Search TODO comments" },
    },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
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
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous hunk")

        -- stylua: ignore start
        map("n", "<leader>ghs", gs.stage_hunk, "Git stage hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Git reset hunk")
        map('v', '<leader>ghs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, "Git stage hunk")
        map('v', '<leader>ghr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, "Git reset hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Git blame line")
        map("n", "<leader>ghd", gs.diffthis, "Git diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Git diff this")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        -- stylua: ignore end
      end,
    },
  },
  { "kmonad/kmonad-vim", ft = "kbd" },
  {
    "chrisbra/csv.vim",
    lazy = false, -- Prevents warning in picker...
    ft = "csv", -- ...This too
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
      { "<leader>rU", "<cmd>ARsyncUpDelete<CR>", desc = "Push with rsync and delete files" },
      { "<leader>rd", "<cmd>ARsyncDown<CR>", desc = "Pull with rsync" },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        symbols = {
          filter = {
            -- NOTE: For some reason does not seem to extend so need to keep markdown and help
            any = { ft = { "quarto", "markdown", "help" } },
          },
        },
      },
    },
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
    cmd = "Trouble",
    -- stylua: ignore
    keys = {
      { "<leader>xD", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xd", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
      { "<leader>xQ", "<Cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<leader>xq", "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
      { "<leader>xl", function() require("trouble").toggle("last") end, desc = "Toggle last Trouble" },
      { "<leader>xt", "<Cmd>Trouble todo toggle<CR>", desc = "TODO comments (Trouble)" },
      { "[q", function() trouble_move("prev") end, desc = "Previous Trouble/Quickfix Item" },
      { "]q", function() trouble_move("next") end, desc = "Next Trouble/Quickfix Item" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = true,
          autohide = true,
          jump_labels = false,
          -- This disables the highlights. It leaves some flicker
          highlight = { backdrop = false },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<CR>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<S-CR>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
