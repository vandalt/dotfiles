return {
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>ahr", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
      { "<leader>ahs", "<cmd>CellularAutomaton scramble<CR>", desc = "Scramble" },
      { "<leader>ahg", "<cmd>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },
}
