-- Aliases for lua + vim -----------------------------------
------------------------------------------------------------
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local execute = vim.api.nvim_command
local cmd = vim.cmd


-- Plugins -------------------------------------------------
------------------------------------------------------------
-- Make sure packer is installed as optional, change opt to start for automatic
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

-- Required if loaded as optional
cmd [[packadd packer.nvim]]

-- Load packages in main file for now
local use = require('packer').use
require('packer').startup(function()

  -- Packer can manage itself as an optional/start plugin
  use {'wbthomason/packer.nvim'}

  use 'tpope/vim-surround'  -- mappings to surround text objects
  use 'tpope/vim-commentary'  -- map gc/gcc to comment
  use 'tpope/vim-repeat'  -- repeat some plugin maps with '.'
  use 'tpope/vim-fugitive'  -- git commands
  use 'tpope/vim-eunuch'  -- Enhanced unix shell commands
  use 'tpope/vim-unimpaired'  -- "Paired" commands with '[' and ']'
  use 'tpope/vim-sleuth'  -- Heuristically set indentation
  use 'bfredl/nvim-luadev'  -- Scratch buffer with lua output (and commands to run lines)
  use 'AndrewRadev/splitjoin.vim'  -- Convert between multi-line and single-line statements
  use 'ryanoasis/vim-devicons'  -- Nice icons in vim
  use 'justinmk/vim-gtfo'  -- Go to terminal (got) or file manager (gof)
  use 'justinmk/vim-dirvish'  -- Alternative directory navigation
  use 'christoomey/vim-tmux-navigator'  -- Navigate vim and tmux with same bindings
  use 'tommcdo/vim-exchange'  -- Exchange text objects with cx/cxx
  use {'junegunn/gv.vim', requires = 'tpope/vim-fugitive'}  -- Navigate commits
  use 'Vimjas/vim-python-pep8-indent'  -- Proper python identation
  use 'vim-scripts/argtextobj.vim'  -- Argument text object
  use 'jeetsukumaran/vim-pythonsense'  -- Text objects and motions for Python
  use 'kana/vim-textobj-user'  -- Below works only if I put this here
  use {'kana/vim-textobj-entire', requires = 'kana/vim-textobj-user'}
  use 'michaeljsmith/vim-indent-object'  -- Indent text object
  use 'vim-scripts/ReplaceWithRegister'  -- Replace text object with register
  use 'bkad/CamelCaseMotion'  -- Camel/sneak case motions (w, b, e)
  use 'easymotion/vim-easymotion'  -- Enhanced motions
  use 'justinmk/vim-sneak'  -- Sneak motions
  use 'adelarsq/vim-matchit'  -- Extended % functionality
  use 'alvan/vim-closetag'  -- Close html tags
  use 'sjl/gundo.vim'  -- Sometimes undo tree is useful
  use 'liuchengxu/vista.vim'  -- Show lsp symbols in side bar
  use 'jiangmiao/auto-pairs'  -- Auto-close pairs
  use 'KenN7/vim-arsync'  -- Sync remote files
  use 'godlygeek/tabular'  -- Align words in vim
  use {'plasticboy/vim-markdown', requires = 'godlygeek/tabular'}
  use {'reedes/vim-textobj-sentence', requires = 'kana/vim-textobj-user'}
  use 'junegunn/goyo.vim'  -- Distraction-free writing
  use 'ferrine/md-img-paste.vim'  -- Paste images automatically with md files
  use {'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim'}
  use 'vimwiki/vimwiki'  -- Note-taking with vimwiki
  use {'tools-life/taskwiki', requires = 'vimwiki/vimwiki'}  -- Taswarrior in vimwiki
  use 'vim-scripts/AnsiEsc.vim'
  use 'goerz/jupytext.vim'  -- Convert and open jupyter notebooks
  use 'GCBallesteros/vim-textobj-hydrogen'
  use 'hkupty/iron.nvim'

  -- Theming plugins
  use 'joshdick/onedark.vim'
  use {'dracula/vim', as = 'dracula'}
  use 'altercation/vim-colors-solarized'
  use 'itchyny/lightline.vim'

  -- LSP and lua
  use 'neovim/nvim-lspconfig'
  use 'tjdevries/nlua.nvim'
  use 'hrsh7th/nvim-compe'

end)

-- General options -----------------------------------------
------------------------------------------------------------
-- Window options
vim.o.mouse = "a"
vim.wo.list = true
vim.o.title = true
vim.o.shortmess = vim.o.shortmess.."c"

-- Save/backup options
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Line numbers
vim.wo.number = true

-- Color column at 80
vim.wo.colorcolumn = "80"

-- Enable filetype plugin
cmd [[filetype plugin on]]

-- Remove trailing spaces
cmd [[autocmd BufWritePre * :%s/\s\+$//e]]

-- Completion in wildmode
local wignorelist = {
  '.git', '.svn',
  '*.jpg', '*.bmp', '*.gif', '*.png', '*.jpeg', '*.pdf', '*.mp3',
  '*.pyc', '*.o', '*.so', '*.out',
  '*.fits', '*.hdf5',
}
vim.o.wildmode = 'longest:full'
vim.o.wildignore = vim.o.wildignore..table.concat(wignorelist, ",")

-- Highlighted yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Key mappings --------------------------------------------
------------------------------------------------------------
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

-- Yank consistent with C and D
vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})

-- Delete next in insert mode
vim.api.nvim_set_keymap("i", "<C-d>", "<Del>", {noremap = true})

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

-- Open and source config file
-- nnoremap <leader>cv :vsplit $MYVIMRC<cr>
-- nnoremap <leader>lv :source $MYVIMRC<cr>
vim.api.nvim_set_keymap('n', '<leader>cv', ':vsplit $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>lv', ':luafile $MYVIMRC<CR>', {noremap = true})

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
vim.api.nvim_set_keymap('n', '<leader>p', ':setlocal paste!<CR>', {})

-- Switch CWD to the directory of the open buffer
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', {})

-- Remove highlights
vim.api.nvim_set_keymap('n', '<ESC>', ':nohlsearch<CR>', {noremap = true})

-- Color scheme --------------------------------------------
------------------------------------------------------------
cmd [[syntax enable]]
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = true
local lsp_highlight_dark = '#504945'
local lsp_highlight_light = '#d5c4a1'
-- local lsp_highlight_dark = 'Grey'
-- local lsp_highlight_light = 'Grey'
cmd [[colorscheme onedark]]

-- Status bar
vim.g.lightline = { colorscheme = 'onedark';
      active = { left = { { 'mode', 'paste' },
                          { 'gitbranch', 'readonly', 'filename', 'modified' }
                        };
      };
      component_function = { gitbranch = 'fugitive#head', };
}

-- Function from solarized plugin to change background and theme
cmd [[call togglebg#map("<F5>")]]

-- Prose----------------------------------------------------
------------------------------------------------------------
-- Toggle spell check
vim.api.nvim_set_keymap('', '<A-f>', ':setlocal spell! spelllang=fr<CR>', {})
vim.api.nvim_set_keymap('', '<A-e>', ':setlocal spell! spelllang=en_ca<CR>', {})

-- Function with a few defaults to write prose (Global so can call in editor)
function Prose(bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  map('n', '<leader>ap', 'vasgq', {noremap = true})  -- Line to paragraph
  map('n', '<leader>al', 'vipJ', {noremap = true})  -- Paragraph to line
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

cmd [[autocmd FileType tex,plaintex lua Prose()]]
cmd [[autocmd BufNewFile,BufRead *.txt lua Prose()]]
cmd [[autocmd BufNewFile,BufRead *.md lua Prose()]]

-- LSP configuration ---------------------------------------
------------------------------------------------------------
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>fa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>fr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>fl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    -- guibg colors are from intellij theme
    local lsp_highilight_fmt = [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=%s
      hi LspReferenceText cterm=bold ctermbg=red guibg=%s
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=%s
    ]]
    if vim.o.background == "dark" then
      local lsp_highilight_cmd = string.format(lsp_highilight_fmt,
        lsp_highlight_dark, lsp_highlight_dark, lsp_highlight_dark)
      vim.api.nvim_exec(lsp_highilight_cmd, false)
    else
      local lsp_highilight_cmd = string.format(lsp_highilight_fmt,
        lsp_highlight_light, lsp_highlight_light, lsp_highlight_light)
      vim.api.nvim_exec(lsp_highilight_cmd, false)
    end
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local autoformat = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- Set some keybinds conditional on server capabilities
  local opts = { noremap=true, silent=true }
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
end

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
      python = {"yapf", "isort"}
      -- python = {"black", "isort"}
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
    latex = {
      rootDirectory = ".",
      build = {
        -- pvc  is for "preview continusly"
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-pvc" },
        executable = "latexmk",
        forwardSearchAfter = true,
        onSave = true
      },
      forwardSearch = {
        executable = "zathura",
        args = {"--synctex-forward", "%l:1:%f", "%p"},
        onSave = true
      }
    }
  }
}

require('nlua.lsp.nvim').setup(nvim_lsp, {
  on_attach = on_attach,
})

-- Autocomplete with compe
vim.o.completeopt = "menuone,noselect"
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

-- Options per filetype ------------------------------------
------------------------------------------------------------
-- Python: always unix fileformat
cmd [[autocmd BufNewFile, BufRead *.py set fileformat=unix]]

-- Options for plugins  ------------------------------------
------------------------------------------------------------
-- Prefix key for CamelCaseMotion
vim.g.camelcasemotion_key = '<leader>'

-- Sneak
-- cmd [[let g:sneak#label = 1]]  -- s matches have labels for quick navigation
vim.api.nvim_set_keymap('', 'f', '<Plug>Sneak_f', {})
vim.api.nvim_set_keymap('', 'F', '<Plug>Sneak_F', {})
vim.api.nvim_set_keymap('', 't', '<Plug>Sneak_t', {})
vim.api.nvim_set_keymap('', 'T', '<Plug>Sneak_T', {})


-- Vista sidebar with lsp
vim.g.vista_default_executive = 'nvim_lsp'
vim.g.vista_sidebar_position = 'vertical botright'
vim.api.nvim_set_keymap('n', '<leader>vv', ':Vista!!<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>vf', ':Vista focus<CR>', {})

-- Paste images in markdown with <leader>p
cmd [[autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>]]

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


local iron = require('iron')

iron.core.set_config {
  preferred = {
    python = "ipython",
  }
}

-- This one conflicts with cl, which replaces s when using sneak
vim.g.iron_map_extended = 0

-- Use mix of iron and hydrogen cell textobj to execute cell (note: ih is broken)
vim.api.nvim_set_keymap('n', '<leader>x', 'ctrah]h', {})

-- Wiki config
vim.g.vimwiki_list = {{path = '~/Documents/notes/',
                       syntax = 'markdown',
                       ext = '.md'}}
