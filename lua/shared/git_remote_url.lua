local M = {}

function M.syscall(cmd)
  return vim.fn.system(cmd):gsub('\n', '')
end

function M.get_submodule_info(path)
  local result = {}
  local submodules = M.syscall({
    'cd', path, '&&', 'git', 'config', '--file', '.gitmodules', '--get-regexp', 'path'
  })

  if submodules ~= '' then
    for line in submodules:gmatch('[^\n]+') do
      local _, submodule_path = line:match('submodule%.(.-)%.path%s+(.*)')
      if submodule_path then
        local full_path = path .. '/' .. submodule_path
        table.insert(result, {
          path = submodule_path,
          full_path = full_path
        })
      end
    end
  end
  return result
end

function M.get_repo_info(path)
  return {
    remote = M.syscall('cd ' .. path .. ' && git remote get-url origin'),
    branch = M.syscall('cd ' .. path .. ' && git branch --show-current'),
    root = M.syscall('cd ' .. path .. ' && git rev-parse --show-toplevel'),
  }
end

function M.get_line_numbers()
  -- find the line number(s)
  local fmt_line_number
  local start_line, end_line
  local current_line = vim.fn.line('.')
  local visual_mode = vim.fn.mode() == 'v' or vim.fn.mode() == 'V'

  if visual_mode then
    -- get visual selection range
    start_line = vim.fn.line('v')
    end_line = vim.fn.line('.')
    -- ensure start_line is the smaller number
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
  end

  -- add line number(s) to URL
  if visual_mode then
    -- add line range for visual selection
    fmt_line_number = '#L' .. start_line .. '-L' .. end_line
  else
    fmt_line_number = '#L' .. current_line -- add single line number
  end

  return fmt_line_number
end

-- @TODO: handle custom remote upstream (non-origin upstream)
function M.get_git_remote_url()
  -- start with the main repository
  local file_path = vim.fn.expand('%:p')
  local current_path = vim.fn.getcwd()
  local current_repo = M.get_repo_info(current_path)
  local fmt_line_number = M.get_line_numbers()
  local final_repo = current_repo

  -- keep track of submodule traversal
  local state_is_submodule_found = true

  while state_is_submodule_found do
    state_is_submodule_found = false
    local submodules = M.get_submodule_info(current_path)
    for _, submodule in ipairs(submodules) do
      if file_path:sub(1, #submodule.full_path) == submodule.full_path then
        -- found a matching submodule, update current path and repo info
        current_path = submodule.full_path
        final_repo = M.get_repo_info(current_path)
        state_is_submodule_found = true
        break
      end
    end
  end

  -- calculate relative path within the final repository
  local remote_url = final_repo.remote:gsub('\n', '')
  local current_branch = final_repo.branch:gsub('\n', '')
  local relative_file_path = file_path:sub(#final_repo.root + 2)

  -- normalize git remote URLs
  -- 1. removing .git suffix from URLs
  -- 2. stripping authentication credentials from HTTPS URLs
  -- 3. converting SSH format (git@github.com:user/repo.git) to HTTPS format
  if remote_url:match('^git@') then
    remote_url = remote_url:gsub(':', '/')
    remote_url = remote_url:gsub('%.git', '')
    remote_url = remote_url:gsub('git@', 'https://')
  elseif remote_url:match('^https://') then
    remote_url = remote_url:gsub('%.git', '')
    remote_url = remote_url:gsub('https://[^@]+@', 'https://')
  end

  local final_url = remote_url .. '/blob/' .. current_branch .. '/' .. relative_file_path .. fmt_line_number

  return final_url
end

return M;
