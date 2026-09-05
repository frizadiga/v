-- generic keymaps
-- see: https://neovim.io/doc/user/map.html or `:help map`

local key = vim.keymap.set
local clipboard = require('shared.clipboard')

-- composite escape
key('i', 'kj', '<Esc>', { desc = 'composite escape insert mode' })
key('v', 'KJ', '<Esc>', { desc = 'composite escape visual mode' })

-- cursor nav
key('n', '<leader>KJ', 'jzz', { desc = 'Move down and center' })
key('n', '<leader>k', '<C-u>zz', { desc = 'Scroll up and center' })
key('n', '<leader>j', '<C-d>zz', { desc = 'Scroll down and center' })

-- quit
key({ 'n', 'v', 'c' }, '<leader>qq', '<CMD>q<CR>', { desc = 'Quit' })

-- redo
key('n', 'r', '<C-r>', { desc = 'Redo' })

-- replace char under cursor
key('n', 'R', 'r', { desc = 'Replace char under cursor' })

-- @start buffer
-- select all text in buffer
key('n', '<leader>a', 'ggVG', { desc = 'Select all text in buffer' })

-- close current buffer
key('n', '<leader>w', '<CMD>bd<CR>', { desc = 'Close current buffer' })

-- force close current buffer (without saving)
key('n', '<leader>W', '<CMD>bd!<CR>', { desc = 'Force close current buffer (without saving)' })

-- close all buffer
key('n', '<leader>Q', '<CMD>bufdo bd<CR>', { desc = 'Close all buffers' })

-- only view this buffer
key('n', '<leader>o', '<CMD>only<CR>', { desc = 'Only view this buffer' })

-- previous buffer
key('n', '<leader>h', '<CMD>bp<CR>', { desc = 'Previous buffer' })

-- next buffer
key('n', '<leader>H', '<CMD>bn<CR>', { desc = 'Next buffer' })

-- write to fs if only buffer is modified
key({ 'n', 'v' }, '<leader><Space>', '<CMD>update<CR>', { desc = 'Write to fs if buffer is modified' })
-- @end buffer

-- @start split view
key('n', '<leader>SP', '<C-w>r', { desc = 'Swap split view position' })
key('n', '<leader>SS', '<C-w><C-w>', { desc = 'Switch to other split view' })
-- @end split view

-- @start search buffer
-- find
-- copy selected text to search input when pressing `/`
key('v', '/', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { desc = 'Search selected text' })

-- replace in buffer
key('n', '<leader>r', ':%s//gc<Left><Left><Left>', { desc = 'Replace in buffer' })
-- in visual mode prefill search with selected text
key('v', '<leader>r', ':<C-u>%s/<C-r><C-w>//gc<Left><Left><Left>', { desc = 'Replace selected text in buffer' })
-- @end search buffer

-- copy to clipboard current file path
key('n', '<leader>cpp', '<CMD>CopyPathAbsolute<CR>', { desc = 'Copy current file path' })

-- copy remote url
key({ 'n', 'x' }, '<leader>cpr', '<CMD>CopyRemoteUrl<CR>', { desc = 'Copy remote url' })

-- open quickfix window
key('n', '<leader>Oq', '<CMD>copen<CR>', { desc = 'Open quickfix window' })

-- move selected block up and down
key("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selected block down' })
key("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selected block up' })

-- normalize word wrap vertical navigation
key('n', 'j', "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true, desc = 'Navigate down' })
key('n', 'k', "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true, desc = 'Navigate up' })

-- @start indentation
-- basic indentation
-- indent right in normal mode
key('n', '<Tab>', '>>', { desc = 'Indent right in normal mode' })
-- indent left in normal mode
key('n', '<S-Tab>', '<<', { desc = 'Indent left in normal mode' })
-- indent left in visual mode and stay in visual mode
key('v', '<', '<gv', { desc = 'Indent left and stay in visual mode' })
-- indent right in visual mode and stay in visual mode
key('v', '>', '>gv', { desc = 'Indent right and stay in visual mode' })

-- auto indent when pasting
key('n', 'p', ']p', { desc = 'Paste with auto-indent' })
key('n', 'P', '[p', { desc = 'Paste with auto-indent (before cursor)' })

-- format specific lines
key('n', '=', '==', { desc = 'Fix indentation for current line' })

-- visual mode specific
key('v', '=', '=', { desc = 'Fix indentation for selected lines' })

-- fix/adjust indentation for entire file
key('n', '<leader>i', 'gg=G<C-o>', { desc = 'Fix indentation for entire file' })
-- @end indentation

-- add workspace folder
-- key('n', '<leader>awf', vim.lsp.buf.add_workspace_folder)

key({ 'n', 'x' }, 'p', function()
  clipboard.set_cleaned_clipboard_register()
  return '"zp'
end, { expr = true, desc = 'Paste cleaned clipboard' })

key('x', '<leader>p', function()
  clipboard.set_cleaned_clipboard_register()
  return '"_d"zP'
end, { expr = true, desc = 'Paste clipboard without yanking selection' })
key({ 'n', 'v' }, '<leader>d', '\"_d', { desc = 'Delete without yanking selection' })
