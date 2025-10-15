-- vim: foldmethod=marker
local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- {{{ Misc useful mappings ============================================================================================
-- mini.deps
map("n", "<leader>mdu", "<Cmd>DepsUpdate<CR>", "MiniDeps Update")
map("n", "<leader>mdc", "<Cmd>DepsClean<CR>", "MiniDeps Delete")

-- Misc useful mappings
map("n", "-", "<Cmd>Oil<CR>", "Open oil.nvim") -- See plugin config for other oil mappings
map("n", "<Esc>", "<Cmd>:nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Normal mode (terminal)")
map({ "n", "x", "o" }, "<CR>", function() require("flash").jump() end, "Flash (jump)")

-- Yank and put from system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard", { remap = true })
map("n", "<leader>Y", [["+Y]], "Yank EOL to system clipboard", { remap = true })
map({ "n", "v" }, "<leader>p", [["+p]], "Put from system clipboard after cursor", { remap = true })
map({ "n", "v" }, "<leader>P", [["+P]], "Put from system clipboard before cursor", { remap = true })

-- Yank and put current path
map("n", "yp", function() require("util").yank_path() end, "Yank current path")
map("n", "<leader>yp", function() require("util").yank_path("+") end, "Yank current to system clipboard")

-- Navigate windows
map("n", "<C-h>", "<C-w>h", "Go to window left")
map("n", "<C-j>", "<C-w>j", "Go to window below")
map("n", "<C-k>", "<C-w>k", "Go to window above")
map("n", "<C-l>", "<C-w>l", "Go to window right")

-- Move Lines, stolen from LazyVim
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", "Move Down")
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", "Move Up")
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move Down")
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move Up")
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", "Move Down")
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Up")

-- Buffers
map("n", "<leader>bd", function() require("mini.bufremove").delete() end, "Close buffer")
map("n", "<leader>bD", "<Cmd>bdelete<CR>", "Close buffer and window")

-- Toggle things (mini.basics has some builtin but not for most plugins)
map("n", "<leader>up", function() vim.g.minipairs_disable = not vim.g.minipairs_disable end, "Toggle pairs")
map("n", "<leader>uu", "<Cmd>Undotree<CR>", "Toggle undotree")

-- rsync
map("n", "<leader>ru", "<Cmd>ARsyncUp<CR>", "Rsync up to remote")
map("n", "<leader>rd", "<Cmd>ARsyncDown<CR>", "Rsync down from remote")

-- Copilot
map("n", "<leader>ai", function() require("sidekick.cli").toggle({ name = "copilot" }) end, "Sidekick")
map("n", "<leader>ap", function() require("sidekick.cli").prompt({ name = "copilot" }) end, "Sidekick prompt")
-- }}}

-- {{{ LSP-related =====================================================================================================
map("n", "grm", "<Cmd>Mason<CR>", "Open Mason")
map("", "grf", function() require("conform").format({ async = true }) end, "Format buffer or selection")

-- Docstrings
map("n", "grd", function() require("neogen").generate() end, "Generate docstrings")
map(
  "n",
  "grp",
  function() require("neogen").generate({ annotation_convention = { python = "numpydoc" } }) end,
  "Numpy docstrings"
)
map(
  "n",
  "grg",
  function() require("neogen").generate({ annotation_convention = { python = "google_docstrins" } }) end,
  "Google docstrings"
)
-- }}}

-- {{{ Treesitter ======================================================================================================
-- Move around text object (selection is configured with mini.ai)
local ts_map = function(lhs, move, query, desc)
  local modes = { "n", "x", "o" }
  map(modes, lhs, function() require("nvim-treesitter-textobjects.move")[move](query) end, desc)
end

local ts_map_all = function(char, query, name)
  name = name or query
  ts_map("]" .. char:lower(), "goto_next_start", query, "next " .. name)
  ts_map("]" .. char:upper(), "goto_next_end", query, "next " .. name .. " end")
  ts_map("[" .. char:lower(), "goto_previous_start", query, "previous " .. name)
  ts_map("[" .. char:upper(), "goto_previous_end", query, "previous " .. name .. " end")
end
ts_map_all("m", "@function.outer", "method")
ts_map_all("c", "@class.outer", "method")
ts_map_all("j", { "@cell.outer", "@cell.comment" }, "cell")
-- }}}

-- {{{ mini plugins ====================================================================================================
map("n", "<leader>ff", function() MiniPick.builtin.files() end, "Find file")
map("n", "<leader>fb", function() MiniPick.builtin.buffers() end, "Find buffer")
map("n", "<leader>fz", function() require("util").pick_chezmoi() end, "Find chezmoi file")
map(
  "n",
  "<leader>fc",
  function() require("util").pick_chezmoi(vim.fn.stdpath("config")) end,
  "Find config file (chezmoi)"
)
map("n", "<leader>sg", function() MiniPick.builtin.grep_live() end, "Search grep")
map("n", "<leader>sh", function() MiniPick.builtin.help() end, "Search help")
map("n", "<leader>sk", function() MiniExtra.pickers.keymaps() end, "Search keymaps")
map("n", "<leader>sm", function() MiniExtra.pickers.marks() end, "Search marks")
map("n", "<leader>gs", function() require("util").pick_git_status() end, "Git status picker")

-- Git
map("n", "<leader>gb", "<Cmd>vertical Git blame -- %<CR>", "Git blame")

-- Sessions
map("n", "<leader>sd", function() require("persistence").stop() end, "Save session")
map("n", "<leader>sr", function() require("persistence").load() end, "Read session")
map("n", "<leader>ss", function() require("persistence").select() end, "Select session")
-- }}}

-- {{{ Debug and test ==================================================================================================
-- Dap
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, "Toggle breakpoint")
map("n", "<leader>dc", function() require("dap").continue() end, "Debug")
map("n", "<leader>do", function() require("dap").step_over() end, "Step over")
map("n", "<leader>dr", function() require("dap").repl.toggle() end, "Toggle dap repl")
map("n", "<leader>di", function() require("dap").step_into() end, "Step into")
map("n", "<leader>du", function() require("dap").up() end, "Go up the stack")
map("n", "<leader>dd", function() require("dap").down() end, "Go down the stack")
map("n", "<leader>dC", function() require("dap").run_to_cursor() end, "Run to Cursor")
map("n", "<leader>dt", function() require("dap").terminate() end, "Terminate")
map("n", "<leader>dl", function() require("osv").launch({ port = 8086 }) end, "OSV server")

-- Neotest
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, "Run File (Neotest)")
map("n", "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, "Run All Test Files (Neotest)")
map("n", "<leader>tn", function() require("neotest").run.run() end, "Run Nearest (Neotest)")
map("n", "<leader>tl", function() require("neotest").run.run_last() end, "Run Last (Neotest)")
map("n", "<leader>ts", function() require("neotest").summary.toggle() end, "Toggle Summary (Neotest)")
map("n", "<leader>tk", function() require("neotest").run.stop() end, "Stop (Neotest)")
-- stylua: ignore
map("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, "Show Output (Neotest)")
map("n", "<leader>tp", function() require("neotest").output_panel.toggle() end, "Toggle Output Panel (Neotest)")
---@diagnostic disable-next-line:missing-fields
map("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, "Debug Nearest test")
-- }}}

-- {{{ REPL ============================================================================================================
local trim_spaces = false
local use_bracketed_paste = true
local tt_opts = { trim_spaces, { args = vim.v.count }, use_bracketed_paste }

-- Run code in toggleterm
map("n", "<leader>rp", "<Cmd>TermExec cmd='python %'<CR>", "Run Python script")
map(
  "n",
  "<leader>jl",
  ---@diagnostic disable-next-line:param-type-mismatch
  function() require("toggleterm").send_lines_to_terminal("single_line", unpack(tt_opts)) end,
  "Send current line to terminal"
)
map(
  "v",
  "<leader>js",
  ---@diagnostic disable-next-line:param-type-mismatch
  function() require("toggleterm").send_lines_to_terminal("visual_selection", unpack(tt_opts)) end,
  "Send current line to terminal"
)
map(
  "n",
  "<leader>js",
  require("util").toggleterm_send_motion(unpack(tt_opts)),
  "Send motion to terminal",
  { expr = true }
)
map("n", "<leader>jh", "m`<leader>jsij``", "Run cell", { remap = true })
map("n", "<leader>jj", "<leader>jsij]j", "Run cell and move", { remap = true })

map("n", "<leader>jo", function() require("otter").activate() end, "Activate otter")

map("n", "<leader>ja", function() require("quarto.runner").run_above() end, "Run cell and above")
map("n", "<leader>jA", function() require("quarto.runner").run_all() end, "Run all cells")
map("n", "<leader>jb", function() require("quarto.runner").run_below() end, "Run cell and below")

map("n", "<leader>jn", "icodeblock<C-j>python<C-l>", "New cell", { remap = true })
map("i", "<C-CR>", "codeblock<C-j>python<C-l>", "New cell", { remap = true })
-- }}}

-- {{{ Notes and markdown ==============================================================================================
-- Markdown preview
map("n", "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", "Toggle markdown preview")

-- Paste images
map("n", "<leader>ip", "<Cmd>PasteImage<CR>", "Paste image")

-- Zk notes
-- stylua: ignore start
map("n", "<leader>zo", function() require("zk").edit() end, "Open zk note")
map("n", "<leader>zw", function() require("zk").new({ dir = "weekly", date = require("util").get_date_zw() }) end, "Weekly note (zk)")
map("n", "<leader>zd", function() require("zk").new({ dir = "daily" }) end, "Daily note (zk)")
map("n", "<leader>zn", function() require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" }) end, "New Note (zk)")
map("x", "<leader>zn", ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<CR>", "New note from title selection")
map("x", "<leader>zc", ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: '), dir = 'zettel' }<CR>", "New note from content selection")
-- stylua: ignore end
-- }}}
