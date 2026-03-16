local M = {}

function M.copy_to_clip(text)
  vim.fn.setreg('+', text)
  vim.notify('copied: ' .. text)
end

-- fix clipboard pasting on windows (remove carriage return characters)
function M.set_cleaned_clipboard_register()
  local raw = vim.fn.getreg('+')
  local regtype = vim.fn.getregtype('+')
  vim.fn.setreg('z', (raw:gsub('\r', '')), regtype)
end

return M;
