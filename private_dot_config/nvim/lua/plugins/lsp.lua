return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false }, -- toggleable with <leader>uh
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              -- disableTaggedHints = true,
              analysis = {
                -- Disable warnings that ruff already provides
                diagnosticSeverityOverrides = {
                  reportUnusedVariable = "none",
                  reportUnusedImport = "none",
                },
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },
}
