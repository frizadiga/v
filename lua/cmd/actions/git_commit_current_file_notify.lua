local M = {}

local show_git_commit_current_file_result =
  require('shared.show_git_commit_current_file_result').show_git_commit_current_file_result

function M.git_commit_current_file_notify()
  show_git_commit_current_file_result('notify')
end

return M
