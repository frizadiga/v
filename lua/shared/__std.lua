local M = {}

function M.syscall(cmd, opts)
  opts = opts or { trim = true }
  -- only trim trailing newline
  return opts.trim and vim.fn.system(cmd):gsub('\n$', '') or vim.fn.system(cmd)
end

function M.print_reverse_lines(output)
  -- split output into lines
  local lines = vim.fn.split(output, '\n')

  -- print reverse of lines
  for i = #lines, 1, -1 do print(lines[i]) end
end

function M.get_env_var(name)
  local value = os.getenv(name)
  if value == nil or value == "" then
    error("Environment variable " .. name .. " is not set")
  end
  return value
end

return M
