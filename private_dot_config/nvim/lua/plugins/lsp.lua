return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
    keys = {
      { "<leader>cm", "<Cmd>Mason<CR>", desc = "Mason" }
    },
  },
  {
    -- TODO: lazydev completion source for cmp or blink
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("vandalt-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- TODO: Use picker for some of these?
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gr", vim.lsp.buf.references, "Goto references")
          map("gI", vim.lsp.buf.implementation, "Goto implementation")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "v" })
        end
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        pyright = {},
      }
      local server_names = vim.tbl_keys(servers)
      require("mason-lspconfig").setup({
        ensure_installed = server_names,
        automatic_installation = false, -- Don't auto-install since we're using handlers below
        handlers = {
          function(server_name)
            local server_opts = servers[server_name]
            server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
            require("lspconfig")[server_name].setup(server_opts)
          end
        },
      })
    end
  },
}
