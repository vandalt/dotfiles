-- vim:foldmethod=marker


-- {{{ Plugins with packer.nvim
-- Make sure packer is installed and optional
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  vim.api.nvim_command 'packadd packer.nvim'
end

-- Required when packer is configured as opt
vim.cmd [[packadd packer.nvim]]
local use = require('packer').use
require('packer').startup(function()
  -- Packer can manage itself
  use {'wbthomason/packer.nvim', opt = true}

  -- Neovim lsp
  use {'neovim/nvim-lspconfig',
       requires = {'tjdevries/nlua.nvim',  -- For lua lsp
                   'RRethy/vim-illuminate',  -- For highlighting with delay
       }
  }

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}


  use 'hrsh7th/nvim-compe'
  -- use {'L3MON4D3/LuaSnip', wants='friendly-snippets'}
  use {'hrsh7th/vim-vsnip', requires='hrsh7th/vim-vsnip-integ'}
  use 'rafamadriz/friendly-snippets'

  use 'tpope/vim-surround'  -- mappings to surround text objects
  use 'tpope/vim-commentary'  -- map gc/gcc to comment
  use 'tpope/vim-repeat'  -- repeat some plugin maps with '.'
  use 'tpope/vim-fugitive'  -- git commands
  use 'tpope/vim-eunuch'  -- Enhanced unix shell commands
  use 'tpope/vim-unimpaired'  -- "Paired" commands with '[' and ']'
  use 'tpope/vim-sleuth'  -- Heuristically set indentation
  use 'tpope/vim-vinegar'  -- nicer file navigation
  use 'AndrewRadev/splitjoin.vim'  -- Convert between multi-line and single-line statements
  use 'justinmk/vim-gtfo'  -- Go to terminal (got) or file manager (gof)
  use 'christoomey/vim-tmux-navigator'  -- Navigate vim and tmux with same bindings
  use 'liuchengxu/vista.vim'  -- Show lsp symbols in side bar
  use 'bkad/CamelCaseMotion'  -- Camel/sneak case motions (w, b, e)
  use 'tommcdo/vim-exchange'  -- Exchange text objects with cx/cxx
  use 'vim-scripts/argtextobj.vim'  -- Argument text object
  use {'GCBallesteros/vim-textobj-hydrogen', requires = 'kana/vim-textobj-user'}
  use 'michaeljsmith/vim-indent-object'  -- Indent text object
  use 'vim-scripts/ReplaceWithRegister'  -- Replace text object with gr
  use 'easymotion/vim-easymotion'  -- hit leader twice before motion to jump somewhere
  use 'andymass/vim-matchup'  -- Extended % functionality
  use 'KenN7/vim-arsync'  -- Sync remote files with rsync
  use {'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim'}
  use 'windwp/nvim-autopairs'
  use 'alvan/vim-closetag'  -- Close html tags
  use 'Glench/Vim-Jinja2-Syntax'  -- HTML templates higlighting
  use {'kkoomen/vim-doge', run = ':call doge#install()'}  -- Auto-generate docstring
  use 'Vimjas/vim-python-pep8-indent'  -- Proper python identation
  use 'jeetsukumaran/vim-pythonsense'  -- Text objects and motions for Python
  use 'goerz/jupytext.vim'  -- Convert and open jupyter notebooks
  use 'hkupty/iron.nvim'  -- REPL
  use 'kshenoy/vim-signature'  -- Toggle, display, navigate marks
  use 'puremourning/vimspector'  -- Debug inside vim
  use 'szw/vim-maximizer'  -- Maximize splits
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-z.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-project.nvim',
    }
  }
  use 'folke/which-key.nvim'
  use 'akinsho/nvim-toggleterm.lua'
  use 'folke/tokyonight.nvim'
  use {"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
  use {
    "nvim-neorg/neorg",
    config = function()
      require('neorg').setup {
        -- Tell Neorg what modules to load
            load = {
              ["core.defaults"] = {}, -- Load all the default modules
              ["core.norg.concealer"] = {}, -- Allows for use of icons
              ["core.norg.dirman"] = { -- Manage your directories with Neorg
                config = {
                  workspaces = {
                    my_workspace = "~/neorg"
                  }
                }
              }
            },
        }
    end,
    requires = "nvim-lua/plenary.nvim"
  }



end)
-- }}}

-- {{{ General options
-- Window options
vim.o.mouse = "a"
vim.wo.list = true
vim.o.title = true
vim.o.shortmess = vim.o.shortmess.."c"
vim.o.hidden = true
vim.o.clipboard = "unnamedplus"

-- Save/backup options
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Color column at 80, 89
vim.wo.colorcolumn = "80,89"

-- Enable filetype plugin
vim.cmd [[filetype plugin on]]

-- Indendation (had problems with vim-sleuth for some python projects)
vim.cmd [[autocmd Filetype cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]]
vim.cmd [[autocmd Filetype lua setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]]
vim.cmd [[autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]]
vim.cmd [[autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]]
vim.cmd [[autocmd BufNewFile, BufRead *.ipynb setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]]
vim.cmd [[autocmd Filetype norg setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]]

-- Remove trailing spaces
vim.cmd [[autocmd BufWritePre * :%s/\s\+$//e]]

-- Completion in wildmode
local wignorelist = {
  '.git', '.svn',
  '*.jpg', '*.bmp', '*.gif', '*.png', '*.jpeg', '*.pdf', '*.mp3',
  '*.pyc', '*.o', '*.so', '*.out',
  '*.fits', '*.hdf5',
}
-- vim.o.wildmode = 'longest:full'
vim.o.wildignore = vim.o.wildignore..table.concat(wignorelist, ",")

-- Hide dotfiles in netrw
vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'

-- Highlighted yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Colors
vim.cmd [[syntax enable]]
vim.o.termguicolors = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
vim.g.tokyonight_style = "night"
vim.cmd [[colorscheme tokyonight]]

-- Python: always unix fileformat
vim.cmd [[autocmd BufNewFile, BufRead *.py set fileformat=unix]]

-- }}}

-- {{{ Custom functions

-- Function with a few defaults to write prose (Global so can call in editor)
-- Toggle spell check

function Prose(bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  map('n', '<leader>ap', 'vasgq', {noremap = true})  -- Line to paragraph
  map('n', '<leader>al', 'vipJ', {noremap = true})  -- Paragraph to line
  vim.bo.textwidth = 80
  vim.bo.formatoptions = vim.bo.formatoptions..'t'  -- Wrap on width
  vim.wo.linebreak = true
  vim.wo.wrap = true
  vim.wo.list = false
  vim.o.display = 'lastline'
  vim.bo.autoindent = false
  vim.bo.cindent = false
  vim.bo.smartindent = false
  vim.bo.indentexpr = ''
  vim.wo.colorcolumn = ''
  map('n', 'j', 'gj', {noremap = true})
  map('n', 'k', 'gk', {noremap = true})
  map('v', 'j', 'gj', {noremap = true})
  map('v', 'k', 'gk', {noremap = true})
end

vim.cmd [[autocmd FileType tex,plaintex lua Prose()]]
-- vim.cmd [[autocmd BufNewFile,BufRead *.txt lua Prose()]]
vim.cmd [[autocmd BufNewFile,BufRead *.md lua Prose()]]

-- }}}

-- {{{ Mappings
--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Tmux and vim navigation
vim.g.tmux_navigator_no_mappings = true
vim.api.nvim_set_keymap("n", "<M-h>", ":TmuxNavigateLeft<CR>", {noremap = true, silent=true})
vim.api.nvim_set_keymap("n", "<M-j>", ":TmuxNavigateDown<CR>", {noremap = true, silent=true})
vim.api.nvim_set_keymap("n", "<M-k>", ":TmuxNavigateUp<CR>", {noremap = true, silent=true})
vim.api.nvim_set_keymap("n", "<M-l>", ":TmuxNavigateRight<CR>", {noremap = true, silent=true})
vim.api.nvim_set_keymap("n", "<M-\\>", ":TmuxNavigatePrevious<CR>", {noremap = true, silent=true})

-- Resize windows
vim.api.nvim_set_keymap('n', '<leader>=', '<C-w>=', {noremap = true})
vim.api.nvim_set_keymap('n', '<M-,>', '<C-w><', {noremap = true})
vim.api.nvim_set_keymap('n', '<M-.>', '<C-w>>', {noremap = true})

-- Edit and load config
vim.api.nvim_set_keymap('n', '<leader>cv', ':vsplit $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>lv', ':luafile $MYVIMRC<CR>', {noremap = true})

-- Yank consistent with C and D
vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})

-- Move line in up or down file
vim.api.nvim_set_keymap('n', '<C-j>', ':m .+1<CR>==', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', ':m .-2<CR>==', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-j>', '<Esc>:m .+1<CR>==gi', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-k>', '<Esc>:m .-2<CR>==gi', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-j>', ':m \'>+1<CR>gv=gv', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-k>', ':m \'<-2<CR>gv=gv', {noremap = true})

-- Switch 0 and ^ (we can use _ instead of ^ to avoid a recursive mapping)
vim.api.nvim_set_keymap("n", "0", "_", {})
vim.api.nvim_set_keymap("n", "^", "999h", {})
vim.api.nvim_set_keymap("n", "<leader>0", "^", {})

-- Escape in terminal
vim.api.nvim_set_keymap('t', '<Esc><Esc>', '<C-\\><C-n>', {noremap = true})

-- Tabs
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>to', ':tabonly<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>tm', ':tabnew<CR>', {})
vim.api.nvim_set_keymap('n', ']]', ':tabnext<CR>', {})
vim.api.nvim_set_keymap('n', '[[', ':tabprev<CR>', {})

-- Toggle line numbers
vim.api.nvim_set_keymap('n', '<leader>ln', ':set number!<CR>', {noremap = true})

-- Toggle list (show tabs, spaces, etc.)
vim.api.nvim_set_keymap('n', '<leader>ll', ':set list!<CR>', {noremap = true})

-- Toggle paste mode
vim.api.nvim_set_keymap('n', '<leader>sp', ':setlocal paste!<CR>', {})

-- Switch CWD to the directory of the open buffer
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', {})

-- Remove search highlights
vim.api.nvim_set_keymap('n', '<ESC>', ':nohlsearch<CR>', {noremap = true})

-- Spell check
vim.api.nvim_set_keymap('', '<A-f>', ':setlocal spell! spelllang=fr<CR>', {})
vim.api.nvim_set_keymap('', '<A-e>', ':setlocal spell! spelllang=en_ca<CR>', {})

-- Packer commands
vim.api.nvim_set_keymap('n', '<leader>pp', ':PackerSync<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ps', ':PackerStatus<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>pi', ':PackerInstall<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>pc', ':PackerCompile<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>pl', ':PackerClean<CR>', {noremap = true})

-- Key before w,b,e for camel/snake
vim.g.camelcasemotion_key = '<leader>'

-- Vista bar
vim.api.nvim_set_keymap('n', '<leader>vv', ':Vista!!<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>vf', ':Vista focus<CR>', {})

-- Use mix of iron and hydrogen cell textobj to execute cell
vim.api.nvim_set_keymap('n', '<leader>ir', ':IronRepl<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>if', ':IronFocus<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>is', ':IronRestart<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>x', 'ctrah]h', {})

-- Doge mapping
vim.g.doge_mapping = '<leader>ld'

-- ARsync mappings
vim.api.nvim_set_keymap("n", "<leader>su", ":ARsyncUp<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>sk", ":ARsyncUpDelete<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>sd", ":ARsyncDown<CR>", {noremap = true})

-- Snippets
-- Expand directly
vim.api.nvim_set_keymap("i", "<C-l>", "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", {expr = true})
vim.api.nvim_set_keymap("s", "<C-l>", "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", {expr = true})
-- Jump forward and backward
vim.api.nvim_set_keymap("i", "<Tab>", "vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "vsnip#jumpable(-1)   ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "vsnip#jumpable(-1)   ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'", {expr = true})

-- }}}

-- {{{ LSP
local nvim_lsp = require('lspconfig')
-- local configs = require('lspconfig/configs')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>af', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>lf', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>sf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>sf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
    vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
    vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
    require 'illuminate'.on_attach(client)
    vim.g.Illuminate_delay = 700
    -- vim.api.nvim_exec([[
    --   augroup lsp_document_highlight
    --     autocmd!
    --     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    --     autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    --   augroup END
    -- ]], false)
  end
end

local autoformat = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- Set some keybinds conditional on server capabilities
  local opts = { noremap=true, silent=true }
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>sf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>sf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
end

local sumneko_binary = 'lua-language-server'
local sumneko_main = '/usr/lib/lua-language-server/main.lua'

require('nlua.lsp.nvim').setup(nvim_lsp, {
  on_attach = on_attach,
  -- cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  cmd = {sumneko_binary, "-E", sumneko_main};
})

-- For python use pyright for navigation and typecheck, diagnosticls for PEP8
nvim_lsp.pyright.setup {
  on_attach = on_attach;
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off";
      }
    }
  }
}
nvim_lsp.diagnosticls.setup {
  on_attach = autoformat;
  filetypes = { "python" };
  init_options = {
    filetypes = {
      python = {"flake8"};
    };
    linters = {
      flake8 = {
        debounce = 100,
        sourceName = "flake8",
        command = "flake8",
        args = {
          "--format",
          "%(row)d:%(col)d:%(code)s:%(code)s: %(text)s",
          "%file",
        },
        formatPattern = {
          "^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
          {
              line = 1,
              column = 2,
              message = {"[", 3, "] ", 5},
              security = 4
          }
        },
        securities = {
          E = "error",
          W = "warning",
          F = "info",
          B = "hint",
        },
      },
    };
    formatFiletypes = {
      -- python = {"yapf", "isort"}
      python = {"black", "isort"}
    };
    formatters = {
      black = {
        command = "black",
        args = { "--quiet", "-" }
      },
      yapf = {
        command = "yapf",
        args = { "--quiet",}
      },
      isort = {
        command = "isort",
        args = { "--quiet", "-" }
      }
    };
  }
}

nvim_lsp.texlab.setup{
  on_attach = on_attach;
  settings = {
    texlab = {
      rootDirectory = ".",
      build = {
        executable = "latexmk",
        -- pvc  is for "preview continusly"
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-pvc", "-xelatex", "%f" },
        forwardSearchAfter = true,
        onSave = true,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true
      },
      forwardSearch = {
        executable = "zathura",
        args = {"--synctex-forward", "%l:1:%f", "%p"},
        -- execute = "evince-synctex",
        -- args = {"-f", "%l", "%p", "\"code -g %f:%l\""},
        onSave = true
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false
      },
      formatterLineLength = 80,
    }
  }
}

nvim_lsp.ccls.setup{on_attach = on_attach}
nvim_lsp.vimls.setup{on_attach = on_attach}

-- }}}

-- {{{ Plugin conf
-- vimspector mappings
-- vim.g.vimspector_enable_mappings = 'HUMAN'
-- Window navigation
vim.api.nvim_set_keymap("n", "<leader>dc", ":call win_gotoid(g:vimspector_session_windows.code)<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dt", ":call win_gotoid(g:vimspector_session_windows.tagpage)<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dv", ":call win_gotoid(g:vimspector_session_windows.variables)<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dw", ":call win_gotoid(g:vimspector_session_windows.watches)<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>ds", ":call win_gotoid(g:vimspector_session_windows.stack_trace)<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>do", ":call win_gotoid(g:vimspector_session_windows.output)<CR>", {noremap = true})
-- debugging controls
vim.api.nvim_set_keymap("n", "<leader>m", ":MaximizerToggle!<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dl", ":call vimspector#Launch()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>de", ":call vimspector#Reset()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>d<space>", "<Plug>VimspectorContinue", {})
vim.api.nvim_set_keymap("n", "<leader>dk", "<Plug>VimspectorStop", {})
vim.api.nvim_set_keymap("n", "<leader>drr", "<Plug>VimspectorRestart", {})
vim.api.nvim_set_keymap("n", "<leader>dp", "<Plug>VimspectorPause", {})
vim.api.nvim_set_keymap("n", "<leader>dbp", "<Plug>VimspectorToggleBreakpoint", {})
vim.api.nvim_set_keymap("n", "<leader>dbc", "<Plug>VimspectorToggleConditionalBreakpoint", {})
vim.api.nvim_set_keymap("n", "<leader>dfb", "<Plug>VimspectorAddFunctionBreakpoint", {})
vim.api.nvim_set_keymap("n", "<leader>drc", "<Plug>VimspectorRunToCursor", {})
vim.api.nvim_set_keymap("n", "<leader>dn", "<Plug>VimspectorStepOver", {})
vim.api.nvim_set_keymap("n", "<leader>dj", "<Plug>VimspectorStepInto", {})
vim.api.nvim_set_keymap("n", "<leader>dk", "<Plug>VimspectorStepOut", {})
vim.api.nvim_set_keymap("n", "<leader>du", "<Plug>VimspectorUpFrame", {})
vim.api.nvim_set_keymap("n", "<leader>dd", "<Plug>VimspectorDownFrame", {})
vim.api.nvim_set_keymap("n", "<leader>di", "<Plug>VimspectorBalloonEval", {})
vim.api.nvim_set_keymap("x", "<leader>di", "<Plug>VimspectorBalloonEval", {})

-- Vista bar
vim.g.vista_default_executive = 'nvim_lsp'
vim.g.vista_sidebar_position = 'vertical botright'

-- Clearer gutter signs (note: codedark broke these)
-- require('gitsigns').setup()
require('gitsigns').setup({
  signs = {
    add          = {hl = 'GitGutterAdd'   , text = '+'},
    change       = {hl = 'GitGutterChange', text = '~'},
    delete       = {hl = 'GitGutterDelete', text = '_'},
    topdelete    = {hl = 'GitGutterDelete', text = '‾'},
    changedelete = {hl = 'GitGutterChange', text = '~'},
  }
})

-- Use %% cells for jupytext
vim.g.jupytext_fmt = 'py:percent'

-- iron REPL
local iron = require('iron')
iron.core.set_config {
  preferred = {
    python = "ipython",
  }
}
vim.g.iron_map_extended = 0  -- cl conflicts with s alternative

-- python docstring types
vim.g.doge_doc_standard_python = 'sphinx'

-- autopair settings (including <CR> mapping compatible with compe)
local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

-- skip it, if you use another global object
_G.MUtils= {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end
remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
-- put this to  setup function and press <a-e> to use fast_wrap
npairs.setup({
    fast_wrap = {},
})

-- nivm-compe configuration
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    vsnip = true;
  };
}

-- Use tab to cycle completion
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.g.poetv_executables = {'poetry'}

-- Telescope extensions
local telescope = require('telescope')
telescope.load_extension('fzy_native')
telescope.load_extension('z')
telescope.setup {
  extensions = {
    project = {
      base_dir = '~',
      max_depth = 3
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {["<c-d>"] = "delete_buffer"}
      }
    }
  }
}

-- built-in telescope mappings
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>f.', [[<cmd>lua require('telescope.builtin').file_browser()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fi', [[<cmd>lua require('telescope.builtin').symbols()<cr>]], {noremap=true})

-- Telescope lsp
vim.api.nvim_set_keymap('n', '<leader>fr', [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fsd', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fsw', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>ftd', [[<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>ftw', [[<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>]], {noremap=true})

-- Github telescope integration
vim.api.nvim_set_keymap('n', '<leader>fgi', [[<cmd>lua require('telescope').extensions.gh.issues()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fgp', [[<cmd>lua require('telescope').extensions.gh.pull_request()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fgg', [[<cmd>lua require('telescope').extensions.gh.gist()<cr>]], {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>fgr', [[<cmd>lua require('telescope').extensions.gh.run()<cr>]], {noremap=true})

-- Telescope projects
vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>lua require'telescope'.extensions.project.project{}<cr>]], {noremap=true, silent=true})

-- zoxide query in telescope
vim.api.nvim_set_keymap('n', '<leader>fz', [[<cmd>lua require'telescope'.extensions.z.list{cmd = {vim.o.shell, "-c", "zoxide query -ls"}}<CR>]], {noremap=true, silent=true})


-- vim.g.dashboard_default_executive = 'telescope'

-- Terminals that can open and close
require('toggleterm').setup{
  open_mapping = [[<A-\>]],
  start_in_insert = false,
}

-- Vimwiki
-- vim.g.vimwiki_list = {{
--   path = '~/projects/notes/',
--   syntax = 'markdown',
--   ext = '.md',
-- }}
-- vim.g.vimwiki_auto_chdir = 1

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
  indent = {enable = false},
}
require('lualine').setup{
  options = {theme = 'tokyonight',
    section_separators = '',  -- on en revient des triangles à moment donné
    component_separators = '',
  }
}
-- }}}
