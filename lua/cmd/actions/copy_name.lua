local M = {}

local copy_to_clip =
  require('shared.clipboard').copy_to_clip

function M.copy_name()
  copy_to_clip(vim.fn.expand('%:t'))
end

return M
