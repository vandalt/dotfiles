return {
  {
    "folke/persistence.nvim",
    -- stylua: ignore
    keys = {
      -- Disable q mappings (leave for quarto) and use t instead, for peris[t], I guess
      -- Don't use ts, used by treesj in coding.lua:
      { "<leader>tr", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>tS", function() require("persistence").select() end, desc = "Select Session" },
      { "<leader>tl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>td", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
      { "<leader>qs", false },
      { "<leader>qS", false },
      { "<leader>ql", false },
      { "<leader>qd", false },
    },
  },
}
