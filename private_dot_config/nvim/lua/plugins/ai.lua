return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = {
        enabled = false, -- Start disabled, toggle with uN
      },
    },
    keys = {
      { "<leader>ai", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
        desc = "Sidekick Toggle Copilot",
      },
    },
  },
}
