local M = {}

function M.hacky_redraw()
  vim.fn.feedkeys('G', 'n')
  vim.cmd('normal! <C-u><C-u><C-d><C-d>')
end

return M
