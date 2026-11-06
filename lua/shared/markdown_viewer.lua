local M = {}

local std = require 'shared.__std'

--- Prepare the current buffer for an external markdown viewer.
--- Validates that a file is open and TOOLS_DIR is set, then flushes unsaved
--- changes so the viewer reads the latest content from disk.
--- @return string|nil file_path
--- @return string|nil tools_dir
function M.prepare()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    vim.notify('No file is currently open', vim.log.levels.WARN)
    return nil
  end

  local ok, tools_dir = pcall(std.get_env_var, 'TOOLS_DIR')
  if not ok then
    vim.notify('TOOLS_DIR is not set', vim.log.levels.ERROR)
    return nil
  end

  -- viewers read from disk, flush unsaved changes first
  vim.cmd('silent update')

  return file_path, tools_dir
end

--- Build the path to a script in $TOOLS_DIR/markdown-viewer.
--- @param tools_dir string
--- @param name string
--- @return string
function M.script(tools_dir, name)
  return tools_dir .. '/markdown-viewer/' .. name
end

return M
