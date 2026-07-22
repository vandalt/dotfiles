return {
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
        },
      },
    },
  },
}
