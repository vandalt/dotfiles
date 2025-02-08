return {
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
    keys = {
      { "<leader>cm", "<Cmd>Mason<CR>", desc = "Mason" },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "LspInfo", "LspStart" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    keys = {
      -- Set this mapping here so can check if LSP even when LspAttach has not run
      { "<leader>ci", "<Cmd>LspInfo<CR>", desc = "LSP Info" },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("vandalt-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gr", require("telescope.builtin").lsp_references, "Goto references")
          map("gI", require("telescope.builtin").lsp_implementations, "Goto implementation")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "v" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          -- map("<leader>ci", "<Cmd>LspInfo<CR>", "LSP Info")

          -- We use pyright for hover so disable that in ruff
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
            map("<leader>co", function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return vim.startswith(action.kind, "source.organizeImports")
                end,
                apply = true,
              })
            end, "Organize Imports (ruff)")
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              }
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              logLevel = "debug",
            }
          }
        },
        texlab = {},
      }

      local server_names = vim.tbl_keys(servers)
      require("mason-lspconfig").setup({
        ensure_installed = server_names,
        automatic_installation = false, -- Don't auto-install since we're using handlers below
        handlers = {
          function(server_name)
            if not servers[server_name] then
              return
            end
            local server_opts = servers[server_name]
            server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
            require("lspconfig")[server_name].setup(server_opts)
          end,
        },
      })
    end,
  },
}
