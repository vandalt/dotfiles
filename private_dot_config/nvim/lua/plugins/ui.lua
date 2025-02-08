return {
  { "akinsho/bufferline.nvim", event = "VeryLazy", opts = { options = { always_show_bufferline = false } } },
  {
    "echasnovski/mini.icons",
    lazy = false,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal",
      })
      return {
        options = { section_separators = "", component_separators = "|" },
        sections = {
          lualine_c = { "filename", { symbols.get, cond = symbols.has } },
          lualine_x = {
            {
              "copilot",
              symbols = { status = { icons = { unknown = "" } } },
            },
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      }
    end,
  },
}
