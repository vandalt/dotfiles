return {
  { "akinsho/bufferline.nvim", event = "VeryLazy", opts = { options = { always_show_bufferline = false } } },
  { "lewis6991/gitsigns.nvim", opts = {} },
  {
    "echasnovski/mini.icons",
    lazy = true,
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
    },
  },
}
