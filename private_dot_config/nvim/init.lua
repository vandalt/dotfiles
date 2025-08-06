local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup()

local opt = vim.opt

-- Keep this near the top
vim.g.mapleader = " "

-- Dedicated venv for pynvim
vim.g.python3_host_prog = os.getenv("HOME") .. "/repos/perso/pynvim/venv/bin/python"

-- Nicer netrw
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+" -- Hide hidden files

opt.number = true -- Line numbers
opt.relativenumber = true -- Relative numbers
opt.signcolumn = "yes" -- Avoids annoying movement
opt.showmode = false -- Mode is in statusline
opt.shiftwidth = 2 -- Smaller tabs because I don't code on a TV
opt.title = true
opt.expandtab = true -- Spaces
opt.ignorecase = true -- Better search
opt.smartcase = true -- Even better search
opt.undofile = true -- Persistent undo
opt.splitbelow = true
opt.splitright = true
opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- Use conform/lsp for gq<textobj>

local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Useful
map("n", "-", "<Cmd>Explore<CR>", "Open netrw")
map("n", "<Esc>", "<Cmd>:nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Normal mode (terminal)")

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

-- LSP-related
map("n", "<leader>cm", "<Cmd>Mason<CR>", "Open Mason")
map("", "<leader>cf", function() require("conform").format({ async = true }) end, "Format buffer")

-- Picker
map("n", "<leader>ff", function() MiniPick.builtin.files() end, "Find file")
map("n", "<leader>sg", function() MiniPick.builtin.grep_live() end, "Search grep")
map("n", "<leader>fb", function() MiniPick.builtin.buffers() end, "Find buffer")
map("n", "<leader>sh", function() MiniPick.builtin.help() end, "Search help")

-- Sessions
map("n", "<leader>ss", function() MiniSessions.write("Session.vim") end, "Save session")
map("n", "<leader>sr", function() MiniSessions.read() end, "Read session")

-- Copilot
map("n", "<leader>ai", "<Cmd>CopilotChatToggle<CR>", "Copilot chat")

-- Dap
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, "Toggle breakpoint")
map("n", "<leader>dc", function() require("dap").continue() end, "Debug")
map("n", "<leader>do", function() require("dap").step_over() end, "Step over")
map("n", "<leader>di", function() require("dap").step_into() end, "Step into")
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

-- REPL
local trim_spaces = false
local bracketed_paste = true

map({ "n", "v" }, "]j", function() require("notebook-navigator").move_cell("d") end, "Next Hydrogen Cell")
map({ "n", "v" }, "[j", function() require("notebook-navigator").move_cell("u") end, "Previous Hydrogen Cell")
map(
  "n",
  "<leader>jh",
  function()
    require("notebook-navigator").run_cell({ use_bracketed_paste = bracketed_paste, trim_spaces = trim_spaces })
  end,
  "Run cell"
)
map(
  "n",
  "<leader>jj",
  function()
    require("notebook-navigator").run_and_move({ use_bracketed_paste = bracketed_paste, trim_spaces = trim_spaces })
  end,
  "Run cell and move"
)

map(
  "n",
  "<leader>jl",
  function()
    require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count }, bracketed_paste)
  end,
  "Send current line to terminal"
)
map(
  "v",
  "<leader>js",
  function()
    require("toggleterm").send_lines_to_terminal(
      "visual_selection",
      trim_spaces,
      { args = vim.v.count },
      bracketed_paste
    )
  end,
  "Send current line to terminal"
)

-- Enter terminal in insert mode (even when not toggleterm)
vim.api.nvim_create_autocmd(
  { "TermOpen", "BufEnter" },
  { pattern = "term://*", callback = function() vim.cmd("startinsert") end }
)

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})
