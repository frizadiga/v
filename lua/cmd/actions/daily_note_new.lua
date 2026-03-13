local M = {}

local open_last_output_file =
  require('shared.open_last_output_file').open_last_output_file

function M.daily_note_new()
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local output = vim.fn.system({ 'bash', notes_dir .. '/app/schd-new-daily.sh' })

  open_last_output_file(output)
  vim.notify('\n' .. output, vim.log.levels.INFO)
end

return M
