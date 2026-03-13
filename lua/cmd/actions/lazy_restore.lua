local M = {}

function M.lazy_restore()
  local lazy = require 'lazy'
  lazy.restore()
end

return M
