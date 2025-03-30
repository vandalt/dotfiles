---@param name string
local function get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
local function get_opts(name)
  local plugin = get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return {
  "tpope/vim-eunuch",
  "justinmk/vim-gtfo",
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local opts = get_opts("mini.surround")
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
  },
  {
    "echasnovski/mini.operators",
    keys = function(_, keys)
      local opts = get_opts("mini.operators")
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
    }
  },
}
