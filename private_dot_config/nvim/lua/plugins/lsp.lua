return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TODO: Move to a python.lua file?
        pyright = {
          settings = {
            python = {
              analysis = {
                -- NOTE: Pyright uses single file diagnosticmode
                -- which means fidget will not be shown by default
                typeCheckingMode = "off",
              }
            }
          }
        },
        ltex = {},
      }
    }
  }
}
