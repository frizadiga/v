local M = {}

local std = require 'shared.__std'

function M.git_commit_current_file_result()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    return false, 'No file is currently open', vim.log.levels.ERROR
  end

  local file_dir = vim.fn.fnamemodify(file_path, ':h')

  local git_root_cmd = 'git -C "' .. file_dir .. '" rev-parse --show-toplevel 2>/dev/null'
  local git_root = std.syscall(git_root_cmd)

  if vim.v.shell_error ~= 0 then
    return false, 'Not in a git repository', vim.log.levels.ERROR
  end

  local rel_path_cmd = string.format('git -C "%s" ls-files --full-name "%s" 2>/dev/null', git_root, file_path)
  local rel_path = std.syscall(rel_path_cmd)

  if rel_path == '' or vim.v.shell_error ~= 0 then
    local git_root_pattern = vim.pesc(git_root .. '/')
    rel_path = file_path:gsub('^' .. git_root_pattern, '')

    if vim.fn.filereadable(git_root .. '/' .. rel_path) == 0 then
      return false, 'File not found in repository: ' .. rel_path, vim.log.levels.ERROR
    end
  end

  local status_cmd = string.format('git -C "%s" status --porcelain "%s"', git_root, rel_path)
  local status_output = std.syscall(status_cmd)

  if status_output == '' then
    return false, 'No changes to commit for: ' .. rel_path, vim.log.levels.WARN
  end

  local add_cmd = string.format('git -C "%s" add "%s"', git_root, rel_path)
  local add_output = vim.fn.system(add_cmd)

  if vim.v.shell_error ~= 0 then
    return false, '# Git Add Failed:\n' .. add_output, vim.log.levels.ERROR
  end

  local commit_cmd = string.format('git -C "%s" commit -m "update %s"', git_root, rel_path)
  local commit_output = vim.fn.system(commit_cmd)

  local result_text = '# Git Add and Commit: ' .. rel_path .. '\n\n'
  if vim.v.shell_error == 0 then
    return true, result_text .. 'SUCCESS!\n\n' .. commit_output, vim.log.levels.INFO
  end

  return false, result_text .. 'COMMIT FAILED!\n\n' .. commit_output, vim.log.levels.ERROR
end

return M
