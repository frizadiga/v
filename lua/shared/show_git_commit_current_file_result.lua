local M = {}

local float_win = require 'shared.float_window'
local open_floating_window = float_win.open_floating_window

local git_commit_current_file = require 'shared.git_commit_current_file_result'
local git_commit_current_file_result = git_commit_current_file.git_commit_current_file_result

function M.show_git_commit_current_file_result(display_mode)
  local _, result_text, level = git_commit_current_file_result()

  if display_mode == 'notify' then
    vim.notify(result_text, level, { title = 'GitCommitCurrentFile' })
    return
  end

  open_floating_window(result_text, 80, 30)
end

return M
