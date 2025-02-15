-- generic keymaps
-- see: https://neovim.io/doc/user/map.html or `:help map`

local key = vim.keymap.set

-- composite escape
key('i', 'kj', '<Esc>')
key('v', 'KJ', '<Esc>')

-- quit
key({'n', 'v', 'c'}, '<leader>qq', '<CMD>q<CR>')

-- redo
key('n', 'r', '<C-r>')

-- replace char under cursor
key('n', 'R', 'r')

-- @start buffer
-- select all text in buffer
key('n', '<leader>a', 'ggVG')

-- close current buffer
key('n', '<leader>w', '<CMD>bd<CR>')

-- force close current buffer (without saving)
key('n', '<leader>W', '<CMD>bd!<CR>')

-- close all buffer
key('n', '<leader>Q', '<CMD>bufdo bd<CR>')

-- only view this buffer
key('n', '<leader>o', '<CMD>only<CR>')

-- previous buffer
key('n', '<leader>h', '<CMD>bp<CR>')

-- next buffer
key('n', '<leader>H', '<CMD>bn<CR>')

-- write to fs if only buffer is modified
key({ 'n', 'x' }, '<Space><Space>', '<CMD>update<CR>')
-- @end buffer

-- @start split view
-- swap split view position
key('n', '<leader>SS', '<C-w>r')
-- switch to other split view
key('n', '<leader>S', '<C-w><C-w>')
-- @end split view

-- @start search buffer
-- find
-- copy selected text to search input when pressing `/`
key('v', '/', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])

-- replace in buffer
key('n', '<leader>r', ':%s//gc<Left><Left><Left>')
-- in visual mode prefill search with selected text
key('v', '<leader>r', ':<C-u>%s/<C-r><C-w>//gc<Left><Left><Left>')
-- @end search buffer

-- copy to clipboard current file path
key('n', '<leader>cpp', '<CMD>CopyPath<CR>')

-- copy remote url
key({ 'n', 'x' }, '<leader>cpr', '<CMD>CopyRemoteUrl<CR>')

-- open quickfix window
key('n', '<leader>Oq', '<CMD>copen<CR>')

-- move selected block up and down
key("v", "J", ":m '>+1<CR>gv=gv")
key("v", "K", ":m '<-2<CR>gv=gv")

-- @start indentation
-- basic indentation
key('n', '<Tab>', '>>')   -- indent right in normal mode
key('n', '<S-Tab>', '<<') -- indent left in normal mode
key('v', '<', '<gv')      -- indent left in visual mode and stay in visual mode
key('v', '>', '>gv')      -- indent right in visual mode and stay in visual mode

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
