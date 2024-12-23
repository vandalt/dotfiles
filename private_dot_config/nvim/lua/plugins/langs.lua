return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "julia", "vim" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        fortls = {},
        julials = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
        vimls = {},
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      anaconda_base_path = os.getenv("HOME") .. "./miniforge3",
      anaconda_envs_path = os.getenv("HOME") .. "./miniforge3/envs",
    },
  },
}
