return {
  { 'akinsho/bufferline.nvim', event = "VeryLazy", opts = { options = {always_show_bufferline = false} } },
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
    "lewis6991/gitsigns.nvim",
    otps = {},
  },
}
