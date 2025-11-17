-- @start create user commands

local std = require 'shared.__std'

local float_win = require 'shared.float_window'
local open_floating_window = float_win.open_floating_window

local clipboard = require 'shared.clipboard'
local copy_to_clip = clipboard.copy_to_clip

local git_remote_url = require 'shared.git_remote_url'
local get_git_remote_url = git_remote_url.get_git_remote_url

local cmd_user = vim.api.nvim_create_user_command

cmd_user(
  'L',
  function(opts)
    vim.cmd('Lazy ' .. opts.args)
  end,
  {
    nargs = '*',
    complete = 'custom,v:lua.require("lazy.view").complete',
    desc = 'Lazy.nvim dashboard'
  }
)

cmd_user(
  'Lr',
  function()
    local lazy = require 'lazy'
    lazy.restore()
  end,
  {
    desc = 'Restore Lazy.nvim deps from lockfile'
  }
)

cmd_user(
  'LSP',
  ':Mason',
  {
    desc = 'Open Mason.nvim LSP'
  }
)

cmd_user(
  'SetFiletype',
  function(opts)
    local filetype = opts.fargs[1]
    if filetype == '' then
      print('No filetype provided')
      return
    end

    vim.bo.filetype = filetype
    print('Filetype set to: ' .. filetype)
  end,
  {
    nargs = 1,
    desc = 'Set filetype for current buffer'
  }
)

cmd_user(
  'RTPList',
  function()
    -- get runtime paths as table
    local output = vim.api.nvim_list_runtime_paths()

    open_floating_window('# RTP List:\n \n' .. table.concat(output, '\n'), 80, 30)
  end,
  {
    desc = 'List nvim runtime paths'
  }
)

cmd_user(
  'ClearShada',
  function()
    local shada_file = vim.fn.stdpath('data') .. '/shada/main.shada'
    local cmd = 'echo "" > ' .. shada_file

    vim.fn.system(cmd)
  end,
  {
    desc = 'Clear shada file'
  }
)

cmd_user(
  'Todo',
  function()
    local tools_dir = vim.fn.expand('$TOOLS_DIR')
    local output = vim.fn.system({ 'bash', tools_dir .. '/todo.sh' })

    open_floating_window('# Todo:\n' .. output, 80, 15)
  end,
  {
    desc = 'Run todo.sh'
  }
)

cmd_user(
  'CopyPathAbsolute',
  function()
    local file_path = vim.fn.expand('%:p')
    copy_to_clip(file_path)
  end,
  {
    desc = 'Copy the current file\'s path to clipboard'
  }
)

cmd_user(
  'CopyPathRelative',
  function()
    local file_path = vim.fn.expand('%:~:.')
    local relative_path = vim.fn.fnamemodify(file_path, ':~:.')
    copy_to_clip(relative_path)
  end,
  {
    desc = 'Copy the current file\'s path (relative to git root) to clipboard'
  }
)

cmd_user(
  'CopyName',
  function()
    local file_name = vim.fn.expand('%:t')
    copy_to_clip(file_name)
  end,
  {
    desc = 'Copy the current file\'s name to clipboard'
  }
)

cmd_user(
  'CopyDir',
  function()
    local dir_path = vim.fn.expand('%:p:h')
    copy_to_clip(dir_path)
  end,
  {
    desc = 'Copy the current directory\'s path to clipboard'
  }
)

cmd_user(
  'CopyRemoteUrl',
  function()
    local remote_url = get_git_remote_url()
    copy_to_clip(remote_url)
  end,
  {
    desc = 'Copy the current file\'s path in remote url to clipboard'
  }
)

cmd_user(
  'GL',
  function()
    -- local output = vim.fn.system({'git', 'log', '--oneline', '--graph', '--decorate', '--all'})
    local output = vim.fn.system({ 'git', 'log', '--pretty=format:- %h %ad %ae\n  msg: %s',
      '--date=format:%Y-%m-%d %H:%M' })

    open_floating_window('# Git Log:\n' .. output, 60, 20)
  end,
  {
    desc = 'Show git log in concise format'
  }
)

cmd_user(
  'GitCommitCurrentFile',
  function()
    local file_path = vim.fn.expand('%:p')
    if file_path == '' then
      print('No file is currently open')
      return
    end

    local file_dir = vim.fn.fnamemodify(file_path, ':h')

    -- get git root, handle potential errors
    local git_root_cmd = 'git -C "' .. file_dir .. '" rev-parse --show-toplevel 2>/dev/null'
    local git_root = std.syscall(git_root_cmd)

    if vim.v.shell_error ~= 0 then
      print('Not in a git repository')
      return
    end

    -- get relative path from git root
    local rel_path_cmd = string.format('git -C "%s" ls-files --full-name "%s" 2>/dev/null', git_root, file_path)
    local rel_path = std.syscall(rel_path_cmd)

    -- if file is not tracked by git, use relative path manually
    if rel_path == '' or vim.v.shell_error ~= 0 then
      -- calculate relative path manually
      local git_root_pattern = vim.pesc(git_root .. '/')
      rel_path = file_path:gsub('^' .. git_root_pattern, '')

      -- verify the file exists relative to git root
      if vim.fn.filereadable(git_root .. '/' .. rel_path) == 0 then
        print('File not found in repository: ' .. rel_path)
        return
      end
    end

    -- check if file has changes to commit
    local status_cmd = string.format('git -C "%s" status --porcelain "%s"', git_root, rel_path)
    local status_output = std.syscall(status_cmd)

    if status_output == '' then
      print('No changes to commit for: ' .. rel_path)
      return
    end

    -- perform git add and commit
    local add_cmd = string.format('git -C "%s" add "%s"', git_root, rel_path)
    local add_output = vim.fn.system(add_cmd)

    if vim.v.shell_error ~= 0 then
      open_floating_window('# Git Add Failed:\n' .. add_output, 80, 30)
      return
    end

    local commit_cmd = string.format('git -C "%s" commit -m "update %s"', git_root, rel_path)
    local commit_output = vim.fn.system(commit_cmd)

    local result_text = '# Git Add and Commit: ' .. rel_path .. '\n\n'
    if vim.v.shell_error == 0 then
      result_text = result_text .. 'SUCCESS!\n\n' .. commit_output
    else
      result_text = result_text .. 'COMMIT FAILED!\n\n' .. commit_output
    end

    open_floating_window(result_text, 80, 30)
  end,
  {
    desc = 'Git add and commit current file'
  }
)

cmd_user(
  'GLF',
  function()
    local file_path = vim.fn.expand('%:p')
    if file_path == '' then
      print('No file is currently open')
      return
    end

    local file_dir = vim.fn.fnamemodify(file_path, ':h')

    -- get git root, handle potential errors
    local git_root_cmd = 'git -C "' .. file_dir .. '" rev-parse --show-toplevel 2>/dev/null'
    local git_root = std.syscall(git_root_cmd)

    if vim.v.shell_error ~= 0 then
      print('Not in a git repository')
      return
    end

    -- get relative path from git root
    local rel_path_cmd = string.format('git -C "%s" ls-files --full-name "%s" 2>/dev/null', git_root, file_path)
    local rel_path = std.syscall(rel_path_cmd)

    -- if file is not tracked by git, use relative path manually
    if rel_path == '' or vim.v.shell_error ~= 0 then
      -- calculate relative path manually
      local git_root_pattern = vim.pesc(git_root .. '/')
      rel_path = file_path:gsub('^' .. git_root_pattern, '')

      -- verify the file exists relative to git root
      if vim.fn.filereadable(git_root .. '/' .. rel_path) == 0 then
        print('File is not tracked by git and not found in repository')
        return
      end
    end

    local cmd = string.format(
      'git -C "%s" log --pretty=format:"- %%h %%ad %%ae%%n  msg: %%s" --date=format:"%%Y-%%m-%%d %%H:%%M" -- "%s"',
      git_root,
      rel_path
    )

    local output = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 or output == '' then
      print('No git history found for this file')
      return
    end

    open_floating_window('# Git Log File: ' .. rel_path .. '\n\n' .. output, 80, 30)
  end,
  {
    desc = 'Git history log for current file'
  }
)

cmd_user(
  'GitRmCachedCurrentFile',
  function()
    local file_path = vim.fn.expand('%:p')
    if file_path == '' then
      print('No file is currently open')
      return
    end
    local file_dir = vim.fn.fnamemodify(file_path, ':h')
    -- get git root, handle potential errors
    local git_root_cmd = 'git -C "' .. file_dir .. '" rev-parse --show-toplevel 2>/dev/null'
    local git_root = std.syscall(git_root_cmd)
    if vim.v.shell_error ~= 0 then
      print('Not in a git repository')
      return
    end

    -- get relative path from git root
    local rel_path_cmd = string.format('git -C "%s" ls-files --full-name "%s" 2>/dev/null', git_root, file_path)
    local rel_path = std.syscall(rel_path_cmd)

    -- if file is not tracked by git, use relative path manually
    if rel_path == '' or vim.v.shell_error ~= 0 then
      -- calculate relative path manually
      local git_root_pattern = vim.pesc(git_root .. '/')
      rel_path = file_path:gsub('^' .. git_root_pattern, '')

      -- verify the file exists relative to git root
      if vim.fn.filereadable(git_root .. '/' .. rel_path) == 0 then
        print('File not found in repository: ' .. rel_path)
        return
      end
    end

    -- perform git rm --cached
    local rm_cmd = string.format('git -C "%s" rm -rf --cached "%s"', git_root, rel_path)
    local rm_output = vim.fn.system(rm_cmd)
    local result_text = '# Git Rm Cached Current File: ' .. rel_path .. '\n\n'

    if vim.v.shell_error == 0 then
      result_text = result_text .. 'SUCCESS!\n\n' .. rm_output
    else
      result_text = result_text .. 'GIT RM CACHED FAILED!\n\n' .. rm_output
    end
    open_floating_window(result_text, 80, 10)
  end,
  {
    desc = 'Git rm -rf --cached current file'
  }
)

cmd_user(
  'MakeExecutable',
  function()
    local file_path = vim.fn.expand('%:p')
    if file_path == '' then
      print('No file is currently open')
      return
    end
    local cmd = 'chmod +x "' .. file_path .. '"'
    vim.fn.system(cmd)
    if vim.v.shell_error == 0 then
      print('Made executable: ' .. file_path)
    else
      print('Failed to make executable: ' .. file_path)
    end
  end,
  {
    desc = 'Make current file executable'
  }
)

cmd_user(
  'D',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bash', notes_dir .. '/app/schd-new-daily.sh' })

    -- get last line of output
    local lines = vim.fn.split(output, '\n')
    local today_filepath = vim.fn.trim(lines[#lines])

    -- if today file exists, open it
    if vim.fn.filereadable(today_filepath) == 1 then
      vim.cmd('e ' .. today_filepath)
    end

    vim.notify('\n' .. output, vim.log.levels.INFO)
  end,
  {
    desc = 'Create new daily note'
  }
)

cmd_user(
  'DL',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bash', notes_dir .. '/app/finder/finder-latest.sh' })

    -- get last line of output
    local lines = vim.fn.split(output, '\n')
    local latest_filepath = vim.fn.trim(lines[#lines])

    -- if latest file exists, open it
    if vim.fn.filereadable(latest_filepath) == 1 then
      vim.cmd('e ' .. latest_filepath)
    end

    vim.notify('\nfinder latest:\n' .. output, vim.log.levels.INFO)
  end,
  {
    desc = 'Open latest daily note'
  }
)

cmd_user(
  'DP',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bash', notes_dir .. '/app/finder/finder-prev.sh' })

    -- get last line of output
    local lines = vim.fn.split(output, '\n')
    local prev_filepath = vim.fn.trim(lines[#lines])

    -- if previous file exists, open it
    if vim.fn.filereadable(prev_filepath) == 1 then
      vim.cmd('e ' .. prev_filepath)
    end

    vim.notify('\nfinder previous:\n' .. output, vim.log.levels.INFO)
  end,
  {
    desc = 'Open previous daily note'
  }
)

cmd_user(
  'TaskDetail',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bun', notes_dir .. '/app/tasks/what_task.ts' })

    open_floating_window('# Task Detail:\n' .. output, 80, 10)
  end,
  {
    desc = 'Show detailed task information'
  }
)

cmd_user(
  'TaskMdOpen',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bash', notes_dir .. '/projects/products/open-md-product.sh', '--path' })

    -- get last line of output
    local lines = vim.fn.split(output, '\n')
    local md_filepath = vim.fn.trim(lines[#lines])

    -- if md file exists, open it
    if vim.fn.filereadable(md_filepath) == 1 then
      vim.cmd('e ' .. md_filepath)
    end

    vim.notify('\n' .. output)
  end,
  {
    desc = 'Open task markdown'
  }
)

cmd_user(
  'TaskMdNew',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bash', notes_dir .. '/projects/products/new-md-product.sh', '--path' })

    -- get last line of output
    local lines = vim.fn.split(output, '\n')
    local md_filepath = vim.fn.trim(lines[#lines])

    -- if md file exists, open it
    if vim.fn.filereadable(md_filepath) == 1 then
      vim.cmd('e ' .. md_filepath)
    end

    vim.notify('\n' .. output)
  end,
  {
    desc = 'Create new task markdown'
  }
)

cmd_user(
  'TaskBrowserTabs',
  function()
    local notes_dir = vim.fn.expand('$NOTES_DIR')
    local output = vim.fn.system({ 'bash', notes_dir .. '/app/browser-tabs/mod-tabs-by-ticket-id.sh' })

    vim.notify('\n' .. output)
  end,
  {
    desc = 'Open browser tabs related to task'
  }
)

cmd_user(
  'T',
  function()
    local money_dir = vim.fn.expand('$MONEY_DIR')
    local output = vim.fn.system({ 'bash', money_dir .. '/trading-tools/new-daily-trading-journal.sh' })

    -- get last line of output
    local lines = vim.fn.split(output, '\n')
    local tj_filepath = vim.fn.trim(lines[#lines])

    -- if tj file exists, open it
    if vim.fn.filereadable(tj_filepath) == 1 then
      vim.cmd('e ' .. tj_filepath)
    end

    vim.notify('\n' .. output)
  end,
  {
    desc = 'Create new trading journal note'
  }
)

-- @end create user commands
