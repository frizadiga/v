local M = {}

local open_floating_window =
  require('shared.float_window').open_floating_window

function M.runtime_path_list()
  local output = vim.api.nvim_list_runtime_paths()
  open_floating_window('# RTP List:\n \n' .. table.concat(output, '\n'), 80, 30)
end

return M
