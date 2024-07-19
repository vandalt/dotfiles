return {
  {
    "folke/persistence.nvim",
    keys = {
      -- Disable q mappings (leave for quarto) and use t instead, for peris[t], I guess
      { "<leader>qs", false },
      { "<leader>ql", false },
      { "<leader>qd", false },
      -- Don't use ts, used by treesj in coding.lua
      { "<leader>tr", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>tl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>td", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    }
  }
}
