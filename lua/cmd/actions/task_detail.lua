local M = {}

local open_floating_window =
  require('shared.float_window').open_floating_window

function M.task_detail()
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local output = vim.fn.system({ 'bun', notes_dir .. '/app/tasks/what_task.ts' })

  open_floating_window('# Task Detail:\n' .. output, 80, 10)
end

return M
