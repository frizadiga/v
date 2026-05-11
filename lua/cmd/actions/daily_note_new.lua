local M = {}

local open_last_output_file =
  require('shared.open_last_output_file').open_last_output_file

function M.daily_note_new(opts)
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local cmd = { 'bash', notes_dir .. '/app/schd-new-daily.sh' }

  if opts.args ~= '' then
    table.insert(cmd, opts.args)
  end

  local output = vim.fn.system(cmd)

  open_last_output_file(output)
  vim.notify('\n' .. output)
end

return M
