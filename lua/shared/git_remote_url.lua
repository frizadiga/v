local M = {}

function M.get_git_remote_url()
  local file_path = vim.fn.expand('%:p')

  -- get submodule info for a given path
  local function get_submodule_info(path)
    local submodules = vim.fn.system('cd ' .. path .. ' && git config --file .gitmodules --get-regexp path'):gsub('\n$', '')
    local result = {}
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

  -- get repository info for a path
  local function get_repo_info(path)
    local root = vim.fn.system('cd ' .. path .. ' && git rev-parse --show-toplevel'):gsub('\n', '')
    -- @TODO: handle custom remote upstream (non-origin)
    local remote = vim.fn.system('cd ' .. path .. ' && git remote get-url origin'):gsub('\n', '')
    local branch = vim.fn.system('cd ' .. path .. ' && git branch --show-current'):gsub('\n', '')
    return {
      root = root,
      remote = remote,
      branch = branch
    }
  end

  -- start with the main repository
  local current_path = vim.fn.getcwd()
  local current_repo = get_repo_info(current_path)
  local final_repo = current_repo
  local found_submodule = true

  while found_submodule do
    found_submodule = false
    local submodules = get_submodule_info(current_path)

    for _, submodule in ipairs(submodules) do
      if file_path:sub(1, #submodule.full_path) == submodule.full_path then
        -- found a matching submodule, update current path and repo info
        current_path = submodule.full_path
        final_repo = get_repo_info(current_path)
        found_submodule = true
        break
      end
    end
  end

  -- calculate relative path within the final repository
  local relative_file_path = file_path:sub(#final_repo.root + 2)
  local remote_url = final_repo.remote:gsub('\n', '')
  local current_branch = final_repo.branch:gsub('\n', '')

  -- process the remote URL
  if remote_url:match('^git@') then
    remote_url = remote_url:gsub(':', '/')
    remote_url = remote_url:gsub('%.git', '')
    remote_url = remote_url:gsub('git@', 'https://')
  end

  if remote_url:match('^https://') then
    remote_url = remote_url:gsub('%.git', '')
    remote_url = remote_url:gsub('https://[^@]+@', 'https://')
  end

  local final_url = remote_url .. '/blob/' .. current_branch .. '/' .. relative_file_path

  return final_url
end

return M;
