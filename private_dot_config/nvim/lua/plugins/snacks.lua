return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    dev = false,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true }, -- Handle big files
      explorer = { enabled = true, replace_netrw = false }, -- Explorer
      gitbrowse = { enabled = true }, -- Browse to GitHub
      image = { enabled = true }, -- Display images
      indent = { enabled = true, animate = { enabled = true } }, -- Indent guides
      lazygit = { enabled = true, configure = true }, -- Lazygit
      notifier = { enabled = true, style = "compact", padding = false }, -- padding has statuscolumn color
      picker = {
        enabled = true,
        ui_select = false,
        layouts = {
          ivy_nopreview = {
            preset = "ivy",
            hidden = {"preview"},
            layout = {}
          }
        },
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "ivy" or "ivy_nopreview"
          end,
        },
      }, -- Pickers
      words = { enabled = true }, -- Highlight words and lsp references
      zen = {
        enabled = true,
        toggles = { dim = false },
      },
      styles = {
        ---@diagnostic disable-next-line: missing-fields
        notification = {
          border = "single", -- default is "rounded"
          wo = { wrap = true },
        },
        ---@diagnostic disable-next-line: missing-fields
        zen = {
          backdrop = { transparent = false },
        },
        ---@diagnostic disable-next-line: missing-fields
        terminal = {
          keys = {
            term_normal = {
              ---@diagnostic disable-next-line: assign-type-mismatch
              { "<esc>", "<esc>", mode = "t" },
            },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.diagnostics():map("<leader>ud")
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference (snacks)", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference (snacks)", mode = { "n", "t" } },
      { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git browse (snacks)" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit (snacks)" },
      { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>wf",  function() Snacks.zen() end, desc = "Toggle focus mode (zen)" },
      { "<leader>wm",  function() Snacks.zen.zoom() end, desc = "Toggle maximization (zen)" },
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find smart" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Search grep" },
      { "<leader>se", function() Snacks.picker.icons() end, desc = "Search emojis and icons" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Search LSP symbvols" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Search help" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search keymaps" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Snacks git status" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
    },
  },
}
