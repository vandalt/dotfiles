return {
  {
    "j-hui/fidget.nvim",
    event = { "LspProgress" },
    opts = {
      notification = {
        window = { winblend = 0 },
      },
    },
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
    -- lazy = false,
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
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

          map("gd", function()
            Snacks.picker.lsp_definitions()
          end, "Goto definition")
          map("gr", function()
            Snacks.picker.lsp_references()
          end, "Goto references")
          map("gI", function()
            Snacks.picker.lsp_implementations()
          end, "Goto implementation")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "v" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename")

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
          elseif client and client.name == "marksman" then
            -- TODO: Enable when zk not enabled (e.g. quarto, readmes, etc.)
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.definitionProvider = false
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- TODO: Remove at some point
      if vim.g.my_cmp_plugin == "cmp" then
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      elseif vim.g.my_cmp_plugin == "blink" then
        capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
        -- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      end

      local servers = {
        bashls = {},
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
        marksman = {
          cmd = { "marksman", "server", "-v=5" },
          filetypes = { "markdown", "markdown.mdx", "quarto", "ipynb" },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              logLevel = "debug",
            },
          },
        },
        texlab = {},
        gopls = {},
        astro = {},
        vtsls = {},
      }
      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
        vim.lsp.config(server_name, server_opts)
        -- vim.lsp.enable(server_name)
      end

      local server_names = vim.tbl_keys(servers)
      require("mason-lspconfig").setup({
        automatic_enable = true, -- Default, included to remove lint error
        ensure_installed = server_names,
      })
    end,
  },
}
