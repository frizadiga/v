local M = {}

local copy_to_clip =
  require('shared.clipboard').copy_to_clip
local get_git_remote_url =
  require('shared.git_remote_url').get_git_remote_url

function M.copy_remote_url()
  copy_to_clip(get_git_remote_url())
end

return M
