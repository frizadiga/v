local M = {}

local std = require 'shared.__std'

local float_win = require 'shared.float_window'
local open_floating_window = float_win.open_floating_window

function M.git_rm_cached_current_file()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    print('No file is currently open')
    return
  end

  local file_dir = vim.fn.fnamemodify(file_path, ':h')
  local git_root_cmd = 'git -C "' .. file_dir .. '" rev-parse --show-toplevel 2>/dev/null'
  local git_root = std.syscall(git_root_cmd)
  if vim.v.shell_error ~= 0 then
    print('Not in a git repository')
    return
  end

  local rel_path_cmd = string.format('git -C "%s" ls-files --full-name "%s" 2>/dev/null', git_root, file_path)
  local rel_path = std.syscall(rel_path_cmd)

  if rel_path == '' or vim.v.shell_error ~= 0 then
    local git_root_pattern = vim.pesc(git_root .. '/')
    rel_path = file_path:gsub('^' .. git_root_pattern, '')

    if vim.fn.filereadable(git_root .. '/' .. rel_path) == 0 then
      print('File not found in repository: ' .. rel_path)
      return
    end
  end

  local rm_cmd = string.format('git -C "%s" rm -rf --cached "%s"', git_root, rel_path)
  local rm_output = vim.fn.system(rm_cmd)
  local result_text = '# Git Rm Cached Current File: ' .. rel_path .. '\n\n'

  if vim.v.shell_error == 0 then
    result_text = result_text .. 'SUCCESS!\n\n' .. rm_output
  else
    result_text = result_text .. 'GIT RM CACHED FAILED!\n\n' .. rm_output
  end

  open_floating_window(result_text, 80, 10)
end

return M
