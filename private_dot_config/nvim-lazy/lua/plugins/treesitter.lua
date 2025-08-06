return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    opts = {
      parsers = {
        "astro",
        "bibtex",
        "c",
        "css",
        "html",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "latex",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "ninja",
        "python",
        "query",
        "rst",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").install(opts.parsers)
      local filetype_seen = {}
      local all_filetypes = {}
      for _, parser in ipairs(opts.parsers) do
        local parser_fts = vim.treesitter.language.get_filetypes(parser)
        for _, ft in ipairs(parser_fts) do
          if not filetype_seen[ft] then
            all_filetypes[#all_filetypes + 1] = ft
            filetype_seen[ft] = true
          end
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = all_filetypes,
        callback = function()
          -- TODO: Disable highlighting for latex
          vim.treesitter.start()
          -- TODO: Sort out this vs what I have in options.lua
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      select = {
        lookahead = true,
        -- Could replace with function but would not save that much space and would complicate
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
          ["@section.outer"] = "V",
        },
        include_surrounding_whitespace = false,
      },
      move = { set_jumps = true },
    },
    keys = {
      {
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer")
        end,
        mode = { "x", "o" },
        desc = "function",
      },
      {
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner")
        end,
        mode = { "x", "o" },
        desc = "function",
      },
      {
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer")
        end,
        mode = { "x", "o" },
        desc = "class",
      },
      {
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner")
        end,
        mode = { "x", "o" },
        desc = "class",
      },
      {
        "ab",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@block.outer")
        end,
        mode = { "x", "o" },
        desc = "block",
      },
      {
        "ib",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@block.inner")
        end,
        mode = { "x", "o" },
        desc = "block",
      },
      {
        "aj",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@code_cell.outer")
        end,
        mode = { "x", "o" },
      },
      {
        "ij",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@code_cell.inner")
        end,
        mode = { "x", "o" },
        desc = "code cell",
      },
      {
        "ah",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@selection.outer")
        end,
        mode = { "x", "o" },
        desc = "selection",
      },
      {
        "]m",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Next function",
      },
      {
        "]c",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Next class",
      },
      {
        "]j",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start({ "@code_cell.inner", "@cell.comment" }, "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Next code cell",
      },
      {
        "]M",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Next function end",
      },
      {
        "]C",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Next class end",
      },
      {
        "]J",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@code_cell.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Next code cell end",
      },
      {
        "[m",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Previous code cell",
      },
      {
        "[c",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Previous class",
      },
      {
        "[j",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start({ "@code_cell.inner", "@cell.comment" }, "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Previous code cell",
      },
      {
        "[M",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Previous function end",
      },
      {
        "[C",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Previous class end",
      },
      {
        "[J",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@code_cell.outer", "textobjects")
        end,
        mode = { "n" , "x" , "o" },
        desc = "Previous code cell end",
      },
    },
  },
}
