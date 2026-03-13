local M = {}

local open_last_output_file =
  require('shared.open_last_output_file').open_last_output_file

function M.trading_journal_new(opts)
  local money_dir = vim.fn.expand('$MONEY_DIR')
  local cmd = { 'bash', money_dir .. '/trading-journal/trading-journal-tools/new-daily-trading-journal.sh' }

  if opts.args ~= '' then
    table.insert(cmd, opts.args)
  end

  local output = vim.fn.system(cmd)

  open_last_output_file(output)
  vim.notify('\n' .. output)
end

return M
