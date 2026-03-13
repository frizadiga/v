local M = {}

local open_last_output_file =
  require('shared.open_last_output_file').open_last_output_file

function M.daily_note_latest()
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local output = vim.fn.system({ 'bash', notes_dir .. '/app/finder/finder-latest.sh' })

  open_last_output_file(output)
  vim.notify('\nfinder latest:\n' .. output, vim.log.levels.INFO)
end

return M
