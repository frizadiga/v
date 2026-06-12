local M = {}

function M.clear_oldfiles()
  vim.v.oldfiles = {}
  vim.cmd('wshada!')
  vim.notify('Oldfiles storage cleared', vim.log.levels.INFO, { title = 'ClearOldfiles' })
end

return M
