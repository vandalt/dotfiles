return {
  -- nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      move = {
        keys = {
          goto_next_start = { ["]m"] = "@function.outer" },
          goto_next_end = { ["]M"] = "@function.outer" },
          goto_previous_start = { ["[m"] = "@function.outer" },
          goto_previous_end = { ["[M"] = "@function.outer" },
        },
      },
    },
  },
}
