local M = {}

function M.clear_shada()
  local shada_file = vim.fn.stdpath('data') .. '/shada/main.shada'
  vim.fn.system('echo "" > ' .. shada_file)
  vim.notify('Shada storage cleared', vim.log.levels.INFO, { title = 'ClearShada' })
end

return M
