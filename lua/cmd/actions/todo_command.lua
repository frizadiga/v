local M = {}

local open_floating_window =
  require('shared.float_window').open_floating_window

function M.todo_command()
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local output = vim.fn.system({ 'bash', notes_dir .. '/main/todo/todo.sh' })

  open_floating_window('# Todo:\n' .. output, 80, 15)
end

return M
