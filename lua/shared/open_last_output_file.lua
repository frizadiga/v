local M = {}

function M.open_last_output_file(output)
  local lines = vim.fn.split(output, '\n')
  local filepath = vim.fn.trim(lines[#lines])

  if vim.fn.filereadable(filepath) == 1 then
    vim.cmd('e ' .. filepath)
  end
end

return M
