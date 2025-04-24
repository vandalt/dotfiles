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
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    opts = {},
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      auto_insert_mode = true,
      question_header = "## vandalt",
      window = {
        width = 0.4,
      },
    },
    keys = {
      { "<leader>aa", "<Cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
    },
  },
  {
    "AndreM222/copilot-lualine", -- Configured in lualine config
    dev = false,
  }
}
