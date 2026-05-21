local M = {}

local open_floating_window = require('shared.float_window').open_floating_window

function M.ai_cmp_server_healthcheck()
  local ai_dir = vim.fn.expand('$AI_MODELS_DIR')
  local output = vim.fn.system({ 'bash', ai_dir .. '/llamacpp-coding-cmp-remote-test.sh' })

  open_floating_window('# LlamaCPP Healthcheck:\n' .. output, 60, 20)
end

return M
