return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      words = { enabled = true }, -- Highlight words and lsp references
      indent = { enabled = true, animate = { enabled = true } }, -- Indent guides
      bigfile = { enabled = true }, -- Handle big files
      gitbrowse = { enabled = true },
      lazygit = { enabled = true, configure = true },
      notifier = { enabled = true, style = "compact" },
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
    },
  },
}
