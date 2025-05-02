-- @start create user commands

local std = require'shared.__std'

local float_win = require'shared.float_window'
local open_floating_window = float_win.open_floating_window

local clipboard = require'shared.clipboard'
local copy_to_clip = clipboard.copy_to_clip

local git_remote_url = require'shared.git_remote_url'
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
    local output = vim.fn.system({ 'git', 'log', '--pretty=format:- %h %ad %ae\n  msg: %s', '--date=format:%Y-%m-%d %H:%M' })

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
    local file_dir = vim.fn.fnamemodify(file_path, ':h')
    local git_root = std.syscall('git -C "' .. file_dir .. '" rev-parse --show-toplevel')
    local rel_path = std.syscall('git -C "' .. file_dir .. '" ls-files --full-name "' .. file_path .. '"')

    local cmd = string.format(
      'git -C "%s" add "%s" && git -C "%s" commit -m "update %s"',
      git_root,
      rel_path,
      git_root,
      rel_path
    )

    local output = vim.fn.system(cmd)

    open_floating_window('# Git Add and Commit:\n' .. output, 80, 30)
  end,
  {
    desc = 'Git add and commit current file'
  }
)

cmd_user(
  'GLF',
  function()
    local file_path = vim.fn.expand('%:p')
    local file_dir = vim.fn.fnamemodify(file_path, ':h')
    local git_root = std.syscall('git -C "' .. file_dir .. '" rev-parse --show-toplevel')
    local rel_path = std.syscall('git -C "' .. file_dir .. '" ls-files --full-name "' .. file_path .. '"')

    local cmd = string.format(
      'git -C "%s" log --pretty=format:"- %%h %%ad %%ae%%n  msg: %%s" --date=format:"%%Y-%%m-%%d %%H:%%M" -- "%s"',
      git_root,
      rel_path
    )

    local output = vim.fn.system(cmd)

    open_floating_window('# Git Log File:\n' .. output, 80, 30)
  end,
  {
    desc = 'Git history log for current file'
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

-- @end create user commands
