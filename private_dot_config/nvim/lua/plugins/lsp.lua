return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        ["*"] = {
          keys = {
            -- Snacks does not play nice with otter so use default for this one
            { "gd", function() vim.lsp.buf.definition() end, desc = "Custom Hover" },
          },
        },
        [vim.g.lazyvim_python_lsp] = {
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
