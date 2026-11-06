local M = {}

local float_win = require 'shared.float_window'
local markdown_viewer = require 'shared.markdown_viewer'

-- view current markdown in a floating terminal via $TOOLS_DIR/markdown-viewer/terminal.sh (glow)
function M.md_view()
  local file_path, tools_dir = markdown_viewer.prepare()
  if not file_path then return end

  local win, buf = float_win.open_floating_window(nil, 0.8, 0.8)
  local width = vim.api.nvim_win_get_width(win)

  vim.fn.jobstart({ markdown_viewer.script(tools_dir, 'terminal.sh'), file_path, '-w', tostring(width - 4) }, {
    term = true,
    on_exit = function(_, code)
      -- keep the float open on failure so the script's error stays readable
      if code ~= 0 then return end
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    end,
  })

  vim.cmd('startinsert')
end

return M
