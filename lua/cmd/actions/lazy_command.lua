local M = {}

function M.lazy_command(opts)
  vim.cmd('Lazy ' .. opts.args)
end

return M
