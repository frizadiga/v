local M = {}

-- view current markdown in a floating terminal via $TOOLS_DIR/markdown-viewer/terminal.sh (glow)
function M.md_view()
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

  -- glow reads from disk, flush unsaved changes first
  vim.cmd('silent update')

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    style = 'minimal',
    border = 'rounded',
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
  })

  vim.fn.jobstart({ tools_dir .. '/markdown-viewer/terminal.sh', file_path, '-w', tostring(width - 4) }, {
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
