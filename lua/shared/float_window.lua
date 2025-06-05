local M = {}

-- fn to open a floating window
function M.open_floating_window(buf_body, width, height)
  local _width = width or 0.6
  local _height = height or 0.6
  local final_width, final_height

  if _width > 1 then
    -- use normal unit
    final_width = _width
  else
    -- use percentage unit of current window
    final_width = math.floor(vim.o.columns * _width)
  end

  if _height > 1 then
    -- use normal unit
    final_height = _height
  else
    -- use percentage unit of current window
    final_height = math.floor(vim.o.lines * _height)
  end

  local row = math.floor((vim.o.lines - final_height) / 2)
  local col = math.floor((vim.o.columns - final_width) / 2)

  -- split the command output into lines
  local buf_lines = vim.split(buf_body, '\n', { plain = true })

  -- create a new buffer and window
  local buf = vim.api.nvim_create_buf(false, true) -- arg: nofile, scratch buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buf_lines)

  -- open the floating window
  vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    border = "rounded",
    relative = "editor",
    row = row,
    col = col,
    width = final_width,
    height = final_height,
  })
end

return M
