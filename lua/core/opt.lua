-- vim options
-- see: https://neovim.io/doc/user/options.html or `:help options`

-- @start_section startup screen
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable default intro
vim.opt.shortmess:append('I')
-- @end_section startup screen

-- @start_section shell
-- set shell to zsh
vim.opt.shell = '/bin/zsh'
-- @end_section shell

-- @start_section shared data
-- :lua print(vim.opt.shada._value)
-- {{!,'100,<50,s10,h}}
-- ! - save global variables
-- '100 - save marks
-- <50 - save 50 lines of command line history
-- s10 - save 10 items in search history
-- h - save 20 lines of command line history
vim.opt.shada = "!,'150,<70,s15,h"
-- vim.opt.shada = "!,'30,f1,<50,s10,h"
-- vim.opt.shada = "!,'100,<50,s10,h" -- default value as of Neovim 0.10
-- @end_section shared data

-- disable swap files
vim.opt.swapfile = false

-- sign column
vim.wo.signcolumn = 'yes' -- (why? prevent layout shift)

-- set autoread
vim.opt.autoread = true -- sync files content from external changes

-- set mapleader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ',' -- Same for `maplocalleader`
-- vim.g.maplocalleader = '\\' -- Same for `maplocalleader`

-- @start_section cursor
-- change cursor type on diff mode
-- docs: https://neovim.io/doc/user/options.html#'guicursor'
-- what does this do?
-- 1. normal mode: block
-- 2. insert mode: horizontal line
-- 3. visual mode: vertical line
-- 4. replace mode: horizontal line
-- 5. command mode: horizontal line
-- 6. operator pending mode: horizontal line
-- 7. terminal mode: block
-- 8. prompt mode: horizontal line
-- 9. select mode: vertical line
vim.opt.guicursor = 'n-c-sm:block,i-ci-ve:hor100,v:hor100,r-cr-o:hor100'
-- @end_section cursor

-- show line numbers
vim.opt.rnu = true -- relative line numbers
vim.wo.number = true -- absolute current cursor line numbers
-- vim.wo.cursorline = true -- highlight current line

-- set fill characters for end of buffer
vim.opt.fillchars = { eob = ' ' }

-- set listchars
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·', extends = '›', precedes = '‹', nbsp = '␣' }

vim.opt.timeoutlen = 1000 -- default is 1000
vim.opt.updatetime = 4000 -- default is 4000

-- use system clipboard
vim.opt.clipboard = 'unnamedplus'

-- set term colors
vim.cmd [[
  highlight Normal guibg=NONE
  highlight Normal ctermbg=NONE
  highlight NonText guibg=NONE
  highlight NonText ctermbg=NONE
]]
vim.opt.termguicolors = true

-- new split windows behavior
vim.opt.splitright = true
vim.opt.splitbelow = false

-- @start_section indent
-- set tabstop and shiftwidth
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 2      -- default spaces for tab
vim.opt.softtabstop = 2  -- default spaces when editing
vim.opt.shiftwidth = 2   -- default spaces for auto indent

-- optional: add indent detection for better results
vim.g.detect_indent = true
vim.g.detect_indent_max_lines = 1000
-- @end_section indent

vim.opt.mouse = '' -- scroll by cursor movement

-- @start lsp
-- show lsp diagnostics on popup
-- ref: https://stackoverflow.com/a/70760302/6893303
vim.diagnostic.config({ virtual_text = false })

-- show line diagnostics automatically in hover window
vim.opt.updatetime = 250 -- default: 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- set completeopt for better completion experience in v0.11+
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
-- @end lsp
