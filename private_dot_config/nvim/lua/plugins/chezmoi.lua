return {
  {
    "xvzc/chezmoi.nvim",
    keys = {
      { "<leader>sz", false },
      { "<leader>fz", require("util").pick_chezmoi, desc = "Chezmoi" },
      {
        "<leader>fc",
        function()
          require("util").pick_chezmoi(vim.fn.stdpath("config"))
        end,
        desc = "Chezmoi nvim files",
      },
    },
  },
}
