local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", dev = false, import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded
    lazy = false,
    -- Leave to false because many plugins don't have frequent releases
    version = false,
  },
  rocks = {
    hererocks = nil,
  },
  ---@diagnostic disable-next-line: assign-type-mismatch
  dev = { path = "~/repos/perso" },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, frequency = 3600 * 24 }, -- automatically check for plugin updates, daily
  change_detection = { notify = false }, -- Don't get notified on config changes
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
