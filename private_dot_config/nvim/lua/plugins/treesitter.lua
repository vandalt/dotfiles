return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      move = {
        keys = {
          goto_next_start = { ["]j"] = { "@cell.outer", "@cell.comment" } },
          goto_next_end = { ["]J"] = { "@cell.outer", "@cell.comment" } },
          goto_previous_start = { ["[j"] = { "@cell.outer", "@cell.comment" } },
          goto_previous_end = { ["[J"] = { "@cell.outer", "@cell.comment" } },
        },
      },
    },
  },
}
