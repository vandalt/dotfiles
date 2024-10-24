-- Use these dotfiles as ref: https://github.com/chrhjoh/dotfiles

-- Create snakemake filetype here: both plugins require it
vim.filetype.add({

  extension = {
    smk = 'snakemake'
  },
  filename = {
    ['Snakefile'] = 'snakemake'
  }
})

return {
  {
    "conform.nvim",
    opts = function(_, opts)
      -- Make sure opts.formatters_by_ft is defined
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Add snakemake
      opts.formatters_by_ft.snakemake = { "snakefmt" }
    end,
  },
  {
    -- https://github.com/snakemake/snakemake/tree/main/misc/vim
    "snakemake/snakemake",
    config = function(plugin)
      -- Equivalent to rtp='misc/vim' upstream docs
      vim.opt.rtp:append(plugin.dir .. "/misc/vim")
    end,
    ft = "snakemake",
    dev = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "snakemake" })
      end
    end,
  },
}
