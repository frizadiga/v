local M = {}

local copy_to_clip =
  require('shared.clipboard').copy_to_clip

function M.copy_path_relative()
  local file_path = vim.fn.expand('%:~:.')
  copy_to_clip(vim.fn.fnamemodify(file_path, ':~:.'))
end

return M
