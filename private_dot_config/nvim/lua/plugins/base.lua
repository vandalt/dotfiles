return {
  "tpope/vim-eunuch",
  "justinmk/vim-gtfo",
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "echasnovski/mini.pairs",
    opts = {
      skip_unbalanced = true, -- Custom option, not part of mini.pairs spec
      mappings = {
        -- TODO: F-strings: complete when f| in Python, ideally not off|, or even better not "off| (any word ending in f)
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%w]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%w]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%w]" },

        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\%w][^%w]',   register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^\\%w][^%w]', register = { cr = false } },
        -- Handle markdown codeblocks by skipping when previous is ``
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\%w(``)][^%w]',   register = { cr = false } },

        [" "] = { action = "open", pair = "  ", neigh_pattern = "[%(%[{][%)%]}]" },
      },
    },
    config = function(_, opts)
      Snacks.toggle({
        name = "Mini Pairs",
        get = function()
          return not vim.g.minipairs_disable
        end,
        set = function(state)
          vim.g.minipairs_disable = not state
        end,
      }):map("<leader>up")
      -- Create default mappings
      local pairs = require("mini.pairs")
      pairs.setup(opts)
      -- Override the open function to skip unbalanced pairs
      local open = pairs.open
      ---@diagnostic disable-next-line: duplicate-set-field
      pairs.open = function(pair, neigh_pattern)
        -- From lazyvim
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        if opts.skip_unbalanced and next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
      -- Add latex
      local map_tex = function()
        MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" })
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("pairs-tex", { clear = true }),
        pattern = "tex",
        callback = map_tex,
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local opts = require("util").get_opts("mini.surround")
      local mappings = {
        { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete Surrounding" },
        { opts.mappings.find, desc = "Find Right Surrounding" },
        { opts.mappings.find_left, desc = "Find Left Surrounding" },
        { opts.mappings.highlight, desc = "Highlight Surrounding" },
        { opts.mappings.replace, desc = "Replace Surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
  },
  {
    "echasnovski/mini.operators",
    keys = function(_, keys)
      local opts = require("util").get_opts("mini.operators")
      local mappings = {
        { opts.exchange.prefix, desc = "Exchange operator" },
        { opts.replace.prefix, desc = "Replace operator" },
        { opts.multiply.prefix, desc = "Multiply operator" },
        { opts.sort.prefix, desc = "Sort operator" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      exchange = { prefix = "cx" },
      replace = { prefix = "cr" },
      multiply = { prefix = "" },
      sort = { prefix = "" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    dev = true,
    opts = {
      shade_terminals = true,
      shading_factor = "-30",
      shading_ratio = "-0.3",
      open_mapping = [[<c-/>]],
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.35
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
    keys = {
      -- { "<c-/>", "", "Toggle Terminal" },
      { "<c-s-/>", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function(_, opts)
      local ai = require("mini.ai")
      require("util").ai_whichkey()
      local new_opts = {
        custom_textobjects = {
          u = ai.gen_spec.function_call(),
          -- Buffer
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
      return vim.tbl_deep_extend("error", opts, new_opts)
    end,
  },
}
