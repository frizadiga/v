local M = {}

local markdown_viewer = require 'shared.markdown_viewer'

-- one preview server at a time, gh-markdown-preview binds a fixed port
local job_id = nil

local function stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end
end

local augroup = vim.api.nvim_create_augroup('MdOpen', { clear = true })
vim.api.nvim_create_autocmd('VimLeavePre', { group = augroup, callback = stop })

-- preview current markdown in browser via $TOOLS_DIR/markdown-viewer/browser.sh (live reload on save)
function M.md_open()
  local file_path, tools_dir = markdown_viewer.prepare()
  if not file_path then return end

  -- restart server so it serves the current file
  stop()

  local stderr = {}
  job_id = vim.fn.jobstart({ markdown_viewer.script(tools_dir, 'browser.sh'), file_path }, {
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
