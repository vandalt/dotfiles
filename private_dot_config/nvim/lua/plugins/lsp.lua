-- TODO: Re-use lazyvim lsp variable
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          filetypes = { "python", "snakemake" },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },
}
