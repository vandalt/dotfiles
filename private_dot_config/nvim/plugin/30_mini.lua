---@diagnostic disable: undefined-global
-- TODO: Fix this properly by making mini globals accessible
-- To minimize the time until first screen draw, modules are enabled in two steps:
-- - Step one enables everything that is needed for first draw with `now()`.
--   Sometimes needed only if Neovim is started as `nvim -- path/to/file`.
-- - Everything else is delayed until the first draw with `later()`.
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Step one ===================================================================
-- Enable 'miniwinter' color scheme. It comes with 'mini.nvim' and uses 'mini.hues'.
now(function() vim.cmd("colorscheme miniwinter") end)

-- Common configuration presets. Example usage:
now(function()
  require("mini.basics").setup({
    -- Options already set in plugin/10_options.lua for more control
    options = { basic = false },
    mappings = {
      -- Create `<C-hjkl>` mappings for window navigation
      windows = true,
      -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
      move_with_alt = true,
    },
  })
end)

-- Icon provider
now(function()
  -- Set up to not prefer extension-based icon for some extensions
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require("mini.icons").setup({
    use_file_extension = function(ext, _) return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)]) end,
  })

  -- Mock 'nvim-tree/nvim-web-devicons' for plugins without 'mini.icons' support.
  -- Not needed for 'mini.nvim' or MiniMax, but might be useful for others.
  later(MiniIcons.mock_nvim_web_devicons)

  -- Add LSP kind icons. Useful for 'mini.completion'.
  later(MiniIcons.tweak_lsp_kind)
end)

-- Notifications provider.
now(function() require("mini.notify").setup() end)

-- Session management. A thin wrapper around `:h mksession`
-- manages session files.
now(function() require("mini.sessions").setup() end)

-- Start screen. This is what is shown when you open Neovim with `nvim`.
now(function() require("mini.starter").setup() end)

-- Statusline. Sets `:h 'statusline'` to show more info in a line below window.
now(function() require("mini.statusline").setup() end)

-- Tabline. Sets `:h 'tabline'` to show all listed buffers in a line at the top.
now(function() require("mini.tabline").setup() end)

-- Step one or two ============================================================
-- Completion and signature help. Implements async "two stage" autocompletion:
now_if_args(function()
  -- Customize post-processing of LSP responses for a better user experience.
  -- Don't show 'Text' suggestions (usually noisy) and show snippets last.
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require("mini.completion").setup({
    lsp_completion = {
      -- Without this config autocompletion is set up through `:h 'completefunc'`.
      -- Although not needed, setting up through `:h 'omnifunc'` is cleaner
      -- (sets up only when needed) and makes it possible to use `<C-u>`.
      source_func = "omnifunc",
      auto_setup = false,
      process_items = process_items,
    },
  })

  -- Set 'omnifunc' for LSP completion only when needed.
  local on_attach = function(ev) vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end
  Config.new_autocmd("LspAttach", nil, on_attach, "Set 'omnifunc'")

  -- Advertise to servers that Neovim now supports certain set of completion and
  -- signature features through 'mini.completion'.
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- Navigate and manipulate file system
now_if_args(function()
  -- Enable directory/file preview
  require("mini.files").setup({ windows = { preview = true } })

  -- Add common bookmarks for every explorer. Example usage inside explorer:
  -- - `'c` to navigate into your config directory
  -- - `g?` to see available bookmarks
  local add_marks = function()
    MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
    local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
    MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
    MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
  end
  Config.new_autocmd("User", "MiniFilesExplorerOpen", add_marks, "Add bookmarks")
end)

-- Miscellaneous small but useful functions
now_if_args(function()
  -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
  require("mini.misc").setup()

  -- Change current working directory based on the current file path. It
  -- searches up the file tree until the first root marker ('.git' or 'Makefile')
  -- and sets their parent directory as a current directory.
  -- This is helpful when simultaneously dealing with files from several projects.
  MiniMisc.setup_auto_root()

  -- Restore latest cursor position on file open
  MiniMisc.setup_restore_cursor()

  -- Synchronize terminal emulator background with Neovim's background to remove
  -- possibly different color padding around Neovim instance
  MiniMisc.setup_termbg_sync()
end)

-- Step two ===================================================================

-- Extra 'mini.nvim' functionality (pickers, ai_spec, hipatterns)
later(function() require("mini.extra").setup() end)

-- Extend and create a/i textobjects
later(function()
  local ai = require("mini.ai")
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      j = Config.combined_cell_spec,
    },
    search_method = "cover",
  })
end)

-- Align text interactively. Example usage:
later(function() require("mini.align").setup() end)

-- Go forward/backward with square brackets
later(function()
  require("mini.bracketed").setup({
    jump = { suffix = "" }
  })
end)

-- Remove buffers. Opened files occupy space in tabline and buffer picker.
later(function() require("mini.bufremove").setup() end)

-- Show next key clues in a bottom right window
later(function()
  local miniclue = require("mini.clue")
  -- TODO: decide if re-ignore stylua for function call
  miniclue.setup({
    clues = {
      -- This is defined in 'plugin/20_keymaps.lua' with Leader group descriptions
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows({ submode_resize = true }), -- Creates a submode to resize mappings
      miniclue.gen_clues.z(),
    },
    -- Explicitly opt-in for set of common keys to trigger clue window
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
      { mode = "n", keys = "\\" }, -- mini.basics
      { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
      { mode = { "n", "x" }, keys = "]" },
      { mode = "i", keys = "<C-x>" }, -- Built-in completion
      { mode = { "n", "x" }, keys = "g" }, -- `g` key
      { mode = { "n", "x" }, keys = "'" }, -- Marks
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' }, -- Registers
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" }, -- Window commands
      { mode = { "n", "x" }, keys = "s" }, -- `s` key (mini.surround, etc.)
      { mode = { "n", "x" }, keys = "z" }, -- `z` key
    },
  })
end)

-- Command line tweaks (completion, autocorrection, autopeek)
later(function() require("mini.cmdline").setup() end)

-- Comment lines (built-in is based on this but has less customization)
later(function() require("mini.comment").setup() end)

-- Work with diff hunks
later(function() require("mini.diff").setup() end)

-- Git integration
later(function() require("mini.git").setup() end)

-- Highlight patterns in text
later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      -- Highlight a fixed set of common words. Will be highlighted in any place,
      -- not like "only in comments".
      fixme = hi_words({ "FIXME" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE" }, "MiniHipatternsNote"),

      -- Highlight hex color string (#aabbcc) with that color as a background
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Visualize and work with indent scope (highlight, motions, textobjects)
later(function() require("mini.indentscope").setup() end)

-- Better, customizable user input
later(function() require("mini.input").setup() end)

-- Jump to next/previous single character
later(function() require("mini.jump").setup() end)

-- Jump within visible lines to pre-defined spots via iterative label filtering.
later(function() require("mini.jump2d").setup() end)

-- Special key mappings
later(function()
  require("mini.keymap").setup()
  -- CR and BS to respect multi-pairs
  MiniKeymap.map_multistep("i", "<CR>", { "minipairs_cr" })
  MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
end)

-- Mini mini mini minimap
later(function()
  local map = require("mini.map")
  map.setup({
    -- Use Braille dots to encode text
    symbols = { encode = map.gen_encode_symbols.dot("4x2") },
    -- Show built-in search matches, 'mini.diff' hunks, and diagnostic entries
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
  })

  -- Map built-in navigation characters to force map refresh
  for _, key in ipairs({ "n", "N", "*", "#" }) do
    local rhs = key
      -- Also open enough folds when jumping to the next match
      .. "zv"
      .. "<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>"
    vim.keymap.set("n", key, rhs)
  end
end)

-- Move any selection in any direction with <M-hjkl>
later(function() require("mini.move").setup() end)

-- Text edit operators
later(function() require("mini.operators").setup() end)

-- Autopairs functionality
later(function()
  require("mini.pairs").setup({ modes = { command = false } }) -- leaving command for easy experimentation
end)

-- Pick anything with single window layout and fast matching
later(function() require("mini.pick").setup() end)

-- Manage and expand snippets
later(function()
  local latex_patterns = { "latex/**/*.json", "**/latex.json" }
  local lang_patterns = {
    tex = latex_patterns,
    plaintex = latex_patterns,
    markdown_inline = { "markdown.json" },
  }

  local snippets = require("mini.snippets")
  local config_path = vim.fn.stdpath("config")
  snippets.setup({
    snippets = {
      -- Always load 'snippets/global.json' from config directory
      snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
      -- Load from 'snippets/' directory of plugins, like 'friendly-snippets'
      snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
  })
end)

-- Split and join arguments
later(function() require("mini.splitjoin").setup() end)

-- Surround actions: add/delete/replace/find/highlight
later(function() require("mini.surround").setup() end)

-- Highlight and remove trailspace
later(function() require("mini.trailspace").setup() end)

-- Track and reuse file system visits
later(function() require("mini.visits").setup() end)
