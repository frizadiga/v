local M = {}

function M.clear_shada()
  local shada_file = vim.fn.stdpath('data') .. '/shada/main.shada'
  vim.fn.system('echo "" > ' .. shada_file)
end

return M
