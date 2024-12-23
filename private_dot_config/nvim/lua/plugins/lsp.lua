return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "barreiroleo/ltex_extra.nvim" },
    },
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        ltex = {
          settings = {
            ltex = {
              checkFrequency="save"
            },
          },
        },
      },
      setup = {
        -- See https://github.com/LazyVim/LazyVim/discussions/403
        ltex = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name == "ltex" then
                require("ltex_extra").setup({
                  load_langs = { "en-CA", "fr" },
                  init_check = true,
                  path = vim.fn.stdpath("config") .. "/spell",
                })
              end
            end
          })
        end,
      },
    },
  }
}
