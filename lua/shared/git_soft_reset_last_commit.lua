local M = {}

local std = require 'shared.__std'

local float_win = require 'shared.float_window'
local open_floating_window = float_win.open_floating_window

local function get_nearest_git_root(start_dir)
  local current_dir = vim.fn.fnamemodify(start_dir, ':p')

  while current_dir ~= '' and current_dir ~= '/' do
    local git_path = current_dir .. '/.git'
    if vim.fn.isdirectory(git_path) == 1 or vim.fn.filereadable(git_path) == 1 then
      return current_dir
    end

    local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
    if parent_dir == current_dir then
      break
    end

    current_dir = parent_dir
  end

  if vim.fn.isdirectory('/.git') == 1 or vim.fn.filereadable('/.git') == 1 then
    return '/'
  end

  return nil
end

function M.git_soft_reset_last_commit()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    vim.notify('No file is currently open', vim.log.levels.ERROR, { title = 'GitSoftReset' })
    return
  end

  local file_dir = vim.fn.fnamemodify(file_path, ':h')
  local git_root = get_nearest_git_root(file_dir)

  if git_root == nil then
    vim.notify('Not in a git repository', vim.log.levels.ERROR, { title = 'GitSoftReset' })
    return
  end

  local last_commit = std.syscall(
    string.format('git -C "%s" log -1 --pretty=format:"%%h %%s" 2>/dev/null', git_root)
  )

  if last_commit == '' or vim.v.shell_error ~= 0 then
    vim.notify('No commit found to reset', vim.log.levels.ERROR, { title = 'GitSoftReset' })
    return
  end

  local reset_cmd = string.format('git -C "%s" reset --soft HEAD~1 2>&1', git_root)
  local reset_output = vim.fn.system(reset_cmd)

  if vim.v.shell_error ~= 0 then
    open_floating_window('# Git Soft Reset Failed:\n\n' .. reset_output, 80, 10)
    return
  end

  local status_output = std.syscall(string.format('git -C "%s" status --short', git_root))
  local result_text = '# Git Soft Reset:\n\nReset commit: ' .. last_commit

  if status_output ~= '' then
    result_text = result_text .. '\n\nStaged changes:\n' .. status_output
  end

  open_floating_window(result_text, 80, 12)
end

return M
