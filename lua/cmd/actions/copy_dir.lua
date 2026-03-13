local M = {}

local copy_to_clip =
  require('shared.clipboard').copy_to_clip

function M.copy_dir()
  copy_to_clip(vim.fn.expand('%:p:h'))
end

return M
