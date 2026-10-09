-- General mappings ===========================================================

-- Many general mappings are created by 'mini.basics', see plugin/30_mini.lua

-- Helper to create a Normal mode mapping
local nmap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

-- Helper to create an insert mode mapping
local imap = function(lhs, rhs, desc)
  vim.keymap.set("i", lhs, rhs, { desc = desc })
end


-- Paste linewise before/after current line
-- Useful to copy a non-line thing (e.g. word) and put it on its own line
nmap("[p", '<Cmd>exe "iput! " . v:register<CR>', "Paste Above")
nmap("]p", '<Cmd>exe "iput "  . v:register<CR>', "Paste Below")

-- Insert common emojis or unicode characters
imap("<M-d>", "📅", "Calendar emoji")
imap("<M-.>", "·", "Point median")

-- Move mappings (many are set by mini.bracketed)
local tsmap = function(lhs, move, textobjs)
  local textobjs_str = type(textobjs) == "table" and table.concat(textobjs, ", ") or textobjs
  local desc = "Inner " .. textobjs_str .. " start"
  vim.keymap.set(
    { "n", "x", "o" },
    lhs,
    function() require("nvim-treesitter-textobjects.move")[move](textobjs, "textobjects") end,
    { desc = desc }
  )
end

tsmap("]j", "goto_next_start", { "@cell.inner", "@cell.comment" })
tsmap("[j", "goto_previous_start", { "@cell.inner", "@cell.comment" })
tsmap("]J", "goto_next_end", "@cell.outer")
tsmap("[J", "goto_previous_end", "@cell.outer")
tsmap("]f", "goto_next_start", "@function.outer")
tsmap("[f", "goto_previous_start", "@function.outer")
tsmap("]F", "goto_next_end", "@function.outer")
tsmap("[F", "goto_previous_end", "@function.outer")
tsmap("]c", "goto_next_start", "@class.outer")
tsmap("[c", "goto_previous_start", "@class.outer")
tsmap("]C", "goto_next_end", "@class.outer")
tsmap("[C", "goto_previous_end", "@class.outer")

-- Escape twice to exit terminal
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Escape terminal" })

-- TODO: decide if re-ignore stylua for all below until end

-- Leader mappings ============================================================

-- Create a global table with information about Leader groups in certain modes.
-- This is used to provide 'mini.clue' with extra clues.
-- Add an entry if you create a new group.
Config.leader_group_clues = {
  { mode = "n", keys = "<Leader>a", desc = "+AI" },
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>e", desc = "+Explore/Edit" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
  { mode = "n", keys = "<Leader>g", desc = "+Git" },
  { mode = "n", keys = "<Leader>j", desc = "+Jupyter/REPL" },
  { mode = "n", keys = "<Leader>l", desc = "+Language" },
  { mode = "n", keys = "<Leader>m", desc = "+Map" },
  { mode = "n", keys = "<Leader>o", desc = "+Other" },
  { mode = "n", keys = "<Leader>r", desc = "+REPL/Terminal" },
  { mode = "n", keys = "<Leader>s", desc = "+Session" },
  { mode = "n", keys = "<Leader>t", desc = "+Tests" },
  { mode = "n", keys = "<Leader>v", desc = "+Visits" },
  { mode = "n", keys = "<Leader>z", desc = "+Zettel" },

  { mode = "x", keys = "<Leader>g", desc = "+Git" },
  { mode = "x", keys = "<Leader>l", desc = "+Language" },
  { mode = "x", keys = "<Leader>z", desc = "+Zettel" },
}

-- Helpers to create `<Leader>` mappings
local nmap_leader = function(suffix, rhs, desc, opts)
  vim.keymap.set("n", "<Leader>" .. suffix, rhs, vim.tbl_extend("error", { desc = desc }, opts or {}))
end
local xmap_leader = function(suffix, rhs, desc) vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc }) end
local nxmap_leader = function(suffix, rhs, desc)
  vim.keymap.set({ "n", "x" }, "<Leader>" .. suffix, rhs, { desc = desc })
end

-- a is for "AI"
nmap_leader("aa", function() require("sidekick.cli").toggle({ name = "copilot" }) end, "Toggle copilot")
nxmap_leader("ap", function()
  require("sidekick.cli").show({ name = "copilot", focus = false })
  require("sidekick.cli").prompt()
end, "Sidekick prompt")

-- b is for "Buffer"
local new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end
nmap_leader("ba", "<Cmd>b#<CR>", "Alternate")
nmap_leader("bd", "<Cmd>lua MiniBufremove.delete()<CR>", "Delete")
nmap_leader("bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", "Delete!")
nmap_leader("bs", new_scratch_buffer, "Scratch")
nmap_leader("bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", "Wipeout")
nmap_leader("bW", "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>", "Wipeout!")

-- d is for "Debug"
nmap_leader("da", function() require("dap").continue({ before = Config.get_args }) end, "Run with Args")
nmap_leader("db", function() require("dap").toggle_breakpoint() end, "Toggle Breakpoint")
nmap_leader(
  "dB",
  function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
  "Breakpoint Condition"
)
nmap_leader("dc", function() require("dap").continue() end, "Run/Continue")
nmap_leader("dC", function() require("dap").run_to_cursor() end, "Run to Cursor")
nmap_leader("dg", function() require("dap").goto_() end, "Go to Line (No Execute)")
nmap_leader("di", function() require("dap").step_into() end, "Step Into")
nmap_leader("dj", function() require("dap").down() end, "Down")
nmap_leader("dk", function() require("dap").up() end, "Up")
nmap_leader("dl", function() require("dap").run_last() end, "Run Last")
nmap_leader("do", function() require("dap").step_over() end, "Step Over")
nmap_leader("dO", function() require("dap").step_out() end, "Step Out")
nmap_leader("dP", function() require("dap").pause() end, "Pause")
nmap_leader("dr", function() require("dap").repl.toggle() end, "Toggle REPL")
nmap_leader("ds", function() require("dap").session() end, "Session")
nmap_leader("dt", function() require("dap").terminate() end, "Terminate")
nmap_leader("du", function() require("dapui").toggle({}) end, "Dap UI")
nmap_leader("dw", function() require("dap.ui.widgets").hover() end, "Widgets")
nxmap_leader("de", function() require("dapui").eval() end, "Eval")

-- e is for "Explore" and "Edit"
-- - All mappings that use `edit_plugin_file` - edit 'plugin/' config files
-- TODO: Use chezmoi.nvim edit command?
local edit_plugin_file = function(filename)
  local config_dir = vim.env.HOME .. "/.local/share/chezmoi/private_dot_config/nvim" -- or vim.fn.stdpath("config")
  return string.format("<Cmd>edit %s/plugin/%s<CR>", config_dir, filename)
end
local edit_init_lua = function()
  local config_dir = vim.env.HOME .. "/.local/share/chezmoi/private_dot_config/nvim" -- or vim.fn.stdpath("config")
  return string.format("<Cmd>edit %s/init.lua<CR>", config_dir)
end
local explore_at_file = "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>"
local explore_quickfix = function() vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen") end
local explore_locations = function() vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen") end

nmap_leader("ed", "<Cmd>lua MiniFiles.open()<CR>", "Directory")
nmap_leader("ef", explore_at_file, "File directory")
nmap_leader("ei", edit_init_lua(), "init.lua")
nmap_leader("ek", edit_plugin_file("20_keymaps.lua"), "Keymaps config")
nmap_leader("em", edit_plugin_file("30_mini.lua"), "MINI config")
nmap_leader("en", "<Cmd>lua MiniNotify.show_history()<CR>", "Notifications")
nmap_leader("eo", edit_plugin_file("10_options.lua"), "Options config")
nmap_leader("ep", edit_plugin_file("40_plugins.lua"), "Plugins config")
nmap_leader("eq", explore_quickfix, "Quickfix list")
nmap_leader("eQ", explore_locations, "Location list")

-- f is for "Fuzzy Find"
local pick_added_hunks_buf = '<Cmd>Pick git_hunks path="%" scope="staged"<CR>'
local pick_workspace_symbols_live = '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>'
local pick_chezmoi = function(args)
  return function() require("chezmoi.pick").mini(args) end
end

nmap_leader("f/", '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader("f:", '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader("fa", '<Cmd>Pick git_hunks scope="staged"<CR>', "Added hunks (all)")
nmap_leader("fA", pick_added_hunks_buf, "Added hunks (buf)")
nmap_leader("fb", "<Cmd>Pick buffers<CR>", "Buffers")
nmap_leader("fc", "<Cmd>Pick git_commits<CR>", "Commits (all)")
nmap_leader("fC", '<Cmd>Pick git_commits path="%"<CR>', "Commits (buf)")
nmap_leader("fd", '<Cmd>Pick diagnostic scope="all"<CR>', "Diagnostic workspace")
nmap_leader("fD", '<Cmd>Pick diagnostic scope="current"<CR>', "Diagnostic buffer")
nmap_leader("fe", function() require("mini_pick_emoji").pick() end, "Emoji")
imap("<C-.>", function() require("mini_pick_emoji").pick() end, "Emoji")
nmap_leader("ff", "<Cmd>Pick files<CR>", "Files")
nmap_leader("fg", "<Cmd>Pick grep_live<CR>", "Grep live")
nmap_leader("fG", '<Cmd>Pick grep pattern="<cword>"<CR>', "Grep current word")
nmap_leader("fh", "<Cmd>Pick help<CR>", "Help tags")
nmap_leader("fH", "<Cmd>Pick hl_groups<CR>", "Highlight groups")
nmap_leader("fk", "<Cmd>Pick keymaps<CR>", "Keymaps")
nmap_leader("fl", '<Cmd>Pick buf_lines scope="all"<CR>', "Lines (all)")
nmap_leader("fL", '<Cmd>Pick buf_lines scope="current"<CR>', "Lines (buf)")
nmap_leader("fm", "<Cmd>Pick git_hunks<CR>", "Modified hunks (all)")
nmap_leader("fM", '<Cmd>Pick git_hunks path="%"<CR>', "Modified hunks (buf)")
nmap_leader("fr", "<Cmd>Pick resume<CR>", "Resume")
nmap_leader("fR", '<Cmd>Pick lsp scope="references"<CR>', "References (LSP)")
nmap_leader("fs", pick_workspace_symbols_live, "Symbols workspace (live)")
nmap_leader("fS", '<Cmd>Pick lsp scope="document_symbol"<CR>', "Symbols document")
nmap_leader("ft", "<Cmd>TermSelect<CR>", "Terminal")
nmap_leader("fp", "<Cmd>Pick hipatterns<CR>", "Hipatterns (all)")
nmap_leader("fP", '<Cmd>Pick hipatterns scope="current"<CR>', "Hipatterns (buf)")
nmap_leader("fv", '<Cmd>Pick visit_paths cwd=""<CR>', "Visit paths (all)")
nmap_leader("fV", "<Cmd>Pick visit_paths<CR>", "Visit paths (cwd)")
nmap_leader("fz", pick_chezmoi(vim.fn.stdpath("config")), "Pick nvim config")
nmap_leader("fZ", pick_chezmoi(), "Pick chezmoi files")
vim.keymap.set("i", "<Leader>fe", function() require("mini_pick_emoji").pick() end, { desc = "Emoji" })

-- g is for "Git"
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. " --follow -- %"
-- local lazygit_toggle = function()
--   if require("toggleterm.terminal").get(9) then
--     vim.cmd("9ToggleTerm")
--   else
--     vim.cmd("9TermExec direction=float cmd='lazygit' name='lazygit' close_on_exit=true")
--   end
-- end

nmap_leader("ga", "<Cmd>Git diff --cached<CR>", "Added diff")
nmap_leader("gA", "<Cmd>Git diff --cached -- %<CR>", "Added diff buffer")
nmap_leader("gc", "<Cmd>Git commit<CR>", "Commit")
nmap_leader("gC", "<Cmd>Git commit --amend<CR>", "Commit amend")
nmap_leader("gd", "<Cmd>Git diff<CR>", "Diff")
nmap_leader("gD", "<Cmd>Git diff -- %<CR>", "Diff buffer")
nmap_leader("gg", function() Config.lazygit:toggle() end, "Lazygit")
nmap_leader("gl", "<Cmd>" .. git_log_cmd .. "<CR>", "Log")
nmap_leader("gL", "<Cmd>" .. git_log_buf_cmd .. "<CR>", "Log buffer")
nmap_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")

xmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection")

-- j is for "Jupyter" (REPL)
local trim_spaces = false
local use_bracketed_paste = true
Config.tt_opts = { trim_spaces, { args = vim.v.count }, use_bracketed_paste }

nmap_leader(
  "jl",
  ---@diagnostic disable-next-line:param-type-mismatch
  function() require("toggleterm").send_lines_to_terminal("single_line", unpack(Config.tt_opts)) end,
  "Send current line to terminal"
)
xmap_leader(
  "js",
  ---@diagnostic disable-next-line:param-type-mismatch
  function() require("toggleterm").send_lines_to_terminal("visual_selection", unpack(Config.tt_opts)) end,
  "Send current line to terminal"
)
nmap_leader(
  "js",
  Config.toggleterm_send_motion(Config.tt_opts[1], Config.tt_opts[2], Config.tt_opts[3]),
  "Send motion to terminal",
  { expr = true }
)
nmap_leader("jh", "m`<leader>jsij``", "Run cell", { remap = true })
nmap_leader("jj", "<leader>jsij]j", "Run cell and move", { remap = true })
nmap_leader("jo", function() require("otter").activate() end, "Activate otter")
nmap_leader("ja", function() require("quarto.runner").run_above() end, "Run cell and above")
nmap_leader("jA", function() require("quarto.runner").run_all() end, "Run all cells")
nmap_leader("jb", function() require("quarto.runner").run_below() end, "Run cell and below")

-- Jupyter snippets
nmap_leader("jn", "icodeblock<C-j>python<C-l>", "New cell", { remap = true })
vim.keymap.set("i", "<C-CR>", "codeblock<C-j>python<C-l>", { desc = "New cell", remap = true })

-- l is for "Language"
-- NOTE: most LSP mappings represent a more structured way of replacing built-in
nmap_leader("la", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Actions")
nmap_leader("ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic popup")
nmap_leader("lf", '<Cmd>lua require("conform").format()<CR>', "Format")
nmap_leader("li", "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation")
nmap_leader("lh", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover")
nmap_leader("ll", "<Cmd>lua vim.lsp.codelens.run()<CR>", "Lens")
nmap_leader("lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
nmap_leader("lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "References")
nmap_leader("ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition")
nmap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")
nmap_leader("lt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition")

xmap_leader("lf", '<Cmd>lua require("conform").format()<CR>', "Format selection")

-- m is for "Map"
nmap_leader("mf", "<Cmd>lua MiniMap.toggle_focus()<CR>", "Focus (toggle)")
nmap_leader("mr", "<Cmd>lua MiniMap.refresh()<CR>", "Refresh")
nmap_leader("ms", "<Cmd>lua MiniMap.toggle_side()<CR>", "Side (toggle)")
nmap_leader("mt", "<Cmd>lua MiniMap.toggle()<CR>", "Toggle")

-- o is for "Other"
nmap_leader("oc", "<Cmd>tabclose<CR>", "Close tab")
nmap_leader("or", "<Cmd>lua MiniMisc.resize_window()<CR>", "Resize to default width")
nmap_leader("ot", "<Cmd>lua MiniTrailspace.trim()<CR>", "Trim trailspace")
nmap_leader("ou", "<Cmd>Undotree<CR>", "Undotree")
nmap_leader("oz",  "<Cmd>lua MiniMisc.zoom()<CR>", "Zoom toggle")
nmap_leader("oZ", function() require("mini_zen").zen() end, "Zen toggle")

-- r is for "REPL" (and terminals)
nmap_leader("rt", '<Cmd>execute v:count1 . "ToggleTerm"<CR>', "Terminal")
nmap_leader("rT", function() vim.cmd("ToggleTerm dir=" .. vim.fn.expand("%:p:h")) end, "Terminal (cwd)")
nmap_leader("rp", "<Cmd>TermExec cmd='python %'<CR>", "Run Python script")
nmap_leader("rr", "<Cmd>TermExec cmd='ipython'<CR>", "IPython REPL")
nmap_leader(
  "rR",
  function() return vim.cmd("TermExec cmd='ipython' dir=" .. vim.fn.expand("%:p:h")) end,
  "IPython REPL (cwd)"
)
nmap_leader("ri", "<Cmd>TermExec cmd='\\%run %'<CR>", "Run IPython script")
vim.keymap.set("n", [[<C-/>]], '<Cmd>execute v:count1 . "ToggleTerm"<CR>', { desc = "Toggle Terminal", silent = true })
vim.keymap.set("i", [[<C-/>]], "<Esc><Cmd>ToggleTerm<CR>", { desc = "Toggle Terminal", silent = true })
vim.keymap.set("t", [[<C-/>]], "<Cmd>ToggleTerm<CR>", { desc = "Toggle Terminal", silent = true })
vim.keymap.set(
  "n",
  [[<C-S-/>]],
  function() vim.cmd("ToggleTerm dir=" .. vim.fn.expand("%:p:h")) end,
  { desc = "Toggle Terminal in current file dir", silent = true }
)

-- s is for "Session"
local session_new = 'vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)'

nmap_leader("sd", '<Cmd>lua MiniSessions.select("delete")<CR>', "Delete")
nmap_leader("sn", "<Cmd>lua " .. session_new .. "<CR>", "New")
nmap_leader("sr", '<Cmd>lua MiniSessions.select("read")<CR>', "Read")
nmap_leader("sR", "<Cmd>lua MiniSessions.restart()<CR>", "Restart")
nmap_leader("sw", "<Cmd>lua MiniSessions.write()<CR>", "Write current")

-- t is for "Tests"
nmap_leader("td", function() require("neotest").run.run({ strategy = "dap" }) end, "Debug Nearest")
nmap_leader("tl", function() require("neotest").run.run_last() end, "Run Last (Neotest)")
nmap_leader(
  "to",
  function() require("neotest").output.open({ enter = true, auto_close = true }) end,
  "Show Output (Neotest)"
)
nmap_leader("tO", function() require("neotest").output_panel.toggle() end, "Toggle Output Panel (Neotest)")
nmap_leader("tr", function() require("neotest").run.run() end, "Run Nearest (Neotest)")
nmap_leader("ts", function() require("neotest").summary.toggle() end, "Toggle Summary (Neotest)")
nmap_leader("tS", function() require("neotest").run.stop() end, "Stop (Neotest)")
nmap_leader("tt", function() require("neotest").run.run(vim.fn.expand("%")) end, "Run File (Neotest)")
nmap_leader("tT", function() require("neotest").run.run(vim.uv.cwd()) end, "Run All Test Files (Neotest)")

-- v is for "Visits"
---@diagnostic disable: undefined-global
local make_pick_core = function(cwd, desc)
  return function()
    local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
    local local_opts = { cwd = cwd, filter = "core", sort = sort_latest }
    MiniExtra.pickers.visit_paths(local_opts, { source = { name = desc } })
  end
end

nmap_leader("vc", make_pick_core("", "Core visits (all)"), "Core visits (all)")
nmap_leader("vC", make_pick_core(nil, "Core visits (cwd)"), "Core visits (cwd)")
nmap_leader("vv", '<Cmd>lua MiniVisits.add_label("core")<CR>', 'Add "core" label')
nmap_leader("vV", '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label')
nmap_leader("vl", "<Cmd>lua MiniVisits.add_label()<CR>", "Add label")
nmap_leader("vL", "<Cmd>lua MiniVisits.remove_label()<CR>", "Remove label")

-- z is for "zk"
-- Get the start date for zk weekly note
--- @param start_week_day? string
local get_date_zw = function(start_week_day)
  start_week_day = start_week_day or "sunday"
  ---@diagnostic disable-next-line: param-type-mismatch
  if string.lower(os.date("%A")) == start_week_day then
    return "today"
  else
    return start_week_day
  end
end

-- Yank the path of the current file to any register
nmap_leader("zo", function() require("zk").edit() end, "Open zk note")
nmap_leader("zl", "<Cmd>ZkLinks<CR>", "Open zk links")
nmap_leader("zb", "<Cmd>ZkBacklinks<CR>", "Open zk backlinks")
nmap_leader("zw", function() require("zk").new({ dir = "weekly", date = get_date_zw() }) end, "Weekly note (zk)")
nmap_leader("zd", function() require("zk").new({ dir = "daily" }) end, "Daily note (zk)")
nmap_leader(
  "zn",
  function() require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" }) end,
  "New Note (zk)"
)
xmap_leader("zn", ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<CR>", "New note from title selection")
xmap_leader(
  "zc",
  ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: '), dir = 'zettel' }<CR>",
  "New note from content selection"
)
