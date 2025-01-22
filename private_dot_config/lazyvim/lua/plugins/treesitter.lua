return {
  {
    "mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects.o = false
      opts.custom_textobjects.f = false
      opts.custom_textobjects.c = false
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Around function" },
            ["if"] = { query = "@function.inner", desc = "Inner function" },
            ["ac"] = { query = "@class.outer", desc = "Around class" },
            ["ic"] = { query = "@class.inner", desc = "Inner class" },
            ["ao"] = {
              query = { "@block.outer", "@conditional.outer", "@loop.outer" },
              desc = "Around conditionl, block, loop",
            },
            ["io"] = {
              query = { "@block.inner", "@conditional.inner", "@loop.inner" },
              desc = "Inner conditionl, block, loop",
            },
          },
          selection_modes = {
            ["@function.outer"] = "V",
            ["@function.inner"] = "V",
            ["@class.outer"] = "V",
            ["@class.inner"] = "V",
            ["@block.outer"] = "V",
            ["@block.inner"] = "V",
            ["@conditional.outer"] = "V",
            ["@conditional.inner"] = "V",
            ["@loop.outer"] = "V",
            ["@loop.inner"] = "V",
          },
          include_surrounding_whitespace = false,
        },
      },
    },
  },
}
