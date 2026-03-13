local M = {}

local open_floating_window =
  require('shared.float_window').open_floating_window

function M.git_log()
  local output = vim.fn.system({
    'git',
    'log',
    '--pretty=format:- %h %ad %ae\n  msg: %s',
    '--date=format:%Y-%m-%d %H:%M',
  })

  open_floating_window('# Git Log:\n' .. output, 60, 20)
end

return M
