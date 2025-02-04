return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
    },
    keys = {
      { "<leader>ae", "<cmd>Copilot enable<CR>", desc = "Enable Copilot" },
      { "<leader>ad", "<cmd>Copilot disable<CR>", desc = "Disable Copilot" },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    opts = {},
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = { auto_insert_mode = true },
    keys = {
      { "<leader>aa", "<Cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
    },
  },
  "AndreM222/copilot-lualine",
}
