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
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   lazy = false,
  -- },
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
  -- {
  --   "mfussenegger/nvim-dap",
  --   -- lazy = false,
  --   -- optional = true,
  --   opts = function()
  --     -- HACK: LazyVim sets host to localhost, which does not work for me because ipv6 or something
  --     -- Ref: https://github.com/LazyVim/LazyVim/issues/3577
  --     local dap = require("dap")
  --     if dap.adapters["codelldb"] then
  --       dap.adapters.codelldb["host"] = "127.0.0.1"
  --     end
  --     -- HACK: But localhost is required for typescript to work...
  --     if dap.adapters["pwa-node"] then
  --       dap.adapters["pwa-node"]["host"] = "localhost"
  --     end
  --   end,
  -- },
}
