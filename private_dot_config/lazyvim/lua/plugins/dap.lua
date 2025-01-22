return {
  {
    "nvim-dap-virtual-text",
    -- Enforce lazy loading so that venv-selector is loaded before
    -- This fixes problem with virtual environment and nvim-dap
    lazy = true,
    optional = true,
    opts = {
      virt_text_pos = "eol", -- Big data structure hide the code if "inline"
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    lazy = false,
    config = function()
      require("dap-python").test_runner = "pytest"
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
      local configurations = require("dap").configurations.python
      for _, configuration in pairs(configurations) do
        -- NOTE: Using brackets instead of . to fix lsp warning. Revert if problems
        configuration["justMyCode"] = false
      end
    end,
  },
}
