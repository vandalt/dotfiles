return {

  -- Snacks utils
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          keys = {
            -- These mappings are useful in the terminal
            nav_h = { "<C-h>", false },
            nav_j = { "<C-j>", false },
            nav_k = { "<C-k>", false },
            nav_l = { "<C-l>", false },
          },
        },
      },
    },
  },
}
