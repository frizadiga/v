local M = {}

function M.task_browser_tabs()
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local output = vim.fn.system({ 'bash', notes_dir .. '/app/browser-tabs/mod-tabs-by-ticket-id.sh' })

  vim.notify('\n' .. output)
end

return M
