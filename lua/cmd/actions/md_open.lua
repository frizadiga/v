local M = {}

-- one preview server at a time, gh-markdown-preview binds a fixed port
local job_id = nil

local function stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end
end

vim.api.nvim_create_autocmd('VimLeavePre', { callback = stop })

-- preview current markdown in browser via $TOOLS_DIR/markdown-viewer/browser.sh (live reload on save)
function M.md_open()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    vim.notify('No file is currently open', vim.log.levels.WARN)
    return
  end

  local tools_dir = os.getenv('TOOLS_DIR')
  if not tools_dir or tools_dir == '' then
    vim.notify('TOOLS_DIR is not set', vim.log.levels.ERROR)
    return
  end

  -- server reads from disk, flush unsaved changes first
  vim.cmd('silent update')

  -- restart server so it serves the current file
  stop()

  local stderr = {}
  job_id = vim.fn.jobstart({ tools_dir .. '/markdown-viewer/browser.sh', file_path }, {
    stderr_buffered = true,
    on_stderr = function(_, data) stderr = data end,
    on_exit = function(id, code)
      if id == job_id then job_id = nil end
      -- 143 = killed by jobstop (SIGTERM), expected
      if code ~= 0 and code ~= 143 then
        vim.notify('MdOpen failed: ' .. table.concat(stderr, '\n'), vim.log.levels.ERROR)
      end
    end,
  })
end

return M
