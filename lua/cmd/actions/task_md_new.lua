local M = {}

local open_last_output_file =
  require('shared.open_last_output_file').open_last_output_file

function M.task_md_new()
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local output = vim.fn.system({ 'bash', notes_dir .. '/projects/products/new-md-product.sh', '--path' })

  open_last_output_file(output)
  vim.notify('\n' .. output)
end

return M
