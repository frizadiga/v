local M = {}

function M.make_executable()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    print('No file is currently open')
    return
  end

  vim.fn.system('chmod +x "' .. file_path .. '"')
  if vim.v.shell_error == 0 then
    print('Made executable: ' .. file_path)
  else
    print('Failed to make executable: ' .. file_path)
  end
end

return M
