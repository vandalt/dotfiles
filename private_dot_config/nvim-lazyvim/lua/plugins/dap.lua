return {
  {
    "mfussenegger/nvim-dap-python",
    lazy = false,
    config = function()
      require("dap-python").setup("debugpy-adapter")

      local dap = require("dap")
      -- Ensure all python configurations disable justMyCode
      for _, config in pairs(dap.configurations.python or {}) do
        if type(config) == "table" then
          config.justMyCode = false
        end
      end
    end,
  },
}
