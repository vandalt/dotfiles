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
    opts = {
      options = { section_separators = "", component_separators = "|" },
      sections = {
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
    },
  },
}
