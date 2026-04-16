return {
  -- sidekick.nvim
  {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "copilot" })
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").show({ name = "copilot", focus = false })
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}
