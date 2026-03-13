-- @start create user commands

local set_filetype = require 'cmd.actions.set_filetype'
local git_commit_current_file_float =
  require('cmd.actions.git_commit_current_file_float').git_commit_current_file_float

local cmd_user = vim.api.nvim_create_user_command

cmd_user(
  'L',
  require('cmd.actions.lazy_command').lazy_command,
  {
    nargs = '*',
    complete = 'custom,v:lua.require("lazy.view").complete',
    desc = 'Lazy.nvim dashboard'
  }
)

cmd_user(
  'Lr',
  require('cmd.actions.lazy_restore').lazy_restore,
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
  set_filetype.set_filetype,
  {
    nargs = 1,
    complete = set_filetype.complete_filetype,
    desc = 'Set filetype for current buffer'
  }
)

cmd_user(
  'RTPList',
  require('cmd.actions.runtime_path_list').runtime_path_list,
  {
    desc = 'List nvim runtime paths'
  }
)

cmd_user(
  'ClearShada',
  require('cmd.actions.clear_shada').clear_shada,
  {
    desc = 'Clear shada file'
  }
)

cmd_user(
  'Todo',
  require('cmd.actions.todo_command').todo_command,
  {
    desc = 'Run todo.sh'
  }
)

cmd_user(
  'CopyPathAbsolute',
  require('cmd.actions.copy_path_absolute').copy_path_absolute,
  {
    desc = 'Copy the current file\'s path to clipboard'
  }
)

cmd_user(
  'CopyPathRelative',
  require('cmd.actions.copy_path_relative').copy_path_relative,
  {
    desc = 'Copy the current file\'s path (relative to git root) to clipboard'
  }
)

cmd_user(
  'CopyName',
  require('cmd.actions.copy_name').copy_name,
  {
    desc = 'Copy the current file\'s name to clipboard'
  }
)

cmd_user(
  'CopyDir',
  require('cmd.actions.copy_dir').copy_dir,
  {
    desc = 'Copy the current directory\'s path to clipboard'
  }
)

cmd_user(
  'CopyRemoteUrl',
  require('cmd.actions.copy_remote_url').copy_remote_url,
  {
    desc = 'Copy the current file\'s path in remote url to clipboard'
  }
)

cmd_user(
  'GL',
  require('cmd.actions.git_log').git_log,
  {
    desc = 'Show git log in concise format'
  }
)

cmd_user(
  'CF',
  require('cmd.actions.git_commit_current_file_notify').git_commit_current_file_notify,
  {
    desc = 'Git add and commit current file with notification'
  }
)

cmd_user(
  'RF',
  require('shared.git_soft_reset_last_commit').git_soft_reset_last_commit,
  {
    desc = 'Git soft reset the latest commit'
  }
)

for _, git_commit_float_cmd in ipairs({
  {
    name = 'CFF',
    desc = 'Alias to GitCommitCurrentFile',
  },
  {
    name = 'GitCommitCurrentFile',
    desc = 'Git add and commit current file in floating window',
  },
}) do
  cmd_user(
    git_commit_float_cmd.name,
    git_commit_current_file_float,
    {
      desc = git_commit_float_cmd.desc
    }
  )
end

cmd_user(
  'GLF',
  require('shared.git_log_current_file').git_log_current_file,
  {
    desc = 'Git history log for current file'
  }
)

cmd_user(
  'GitRmCachedCurrentFile',
  require('shared.git_rm_cached_current_file').git_rm_cached_current_file,
  {
    desc = 'Git rm -rf --cached current file'
  }
)

cmd_user(
  'MakeExecutable',
  require('cmd.actions.make_executable').make_executable,
  {
    desc = 'Make current file executable'
  }
)

cmd_user(
  'D',
  require('cmd.actions.daily_note_new').daily_note_new,
  {
    desc = 'Create new daily note'
  }
)

cmd_user(
  'DL',
  require('cmd.actions.daily_note_latest').daily_note_latest,
  {
    desc = 'Open latest daily note'
  }
)

cmd_user(
  'DP',
  require('cmd.actions.daily_note_previous').daily_note_previous,
  {
    desc = 'Open previous daily note'
  }
)

cmd_user(
  'TaskDetail',
  require('cmd.actions.task_detail').task_detail,
  {
    desc = 'Show detailed task information'
  }
)

cmd_user(
  'TaskMdOpen',
  require('cmd.actions.task_md_open').task_md_open,
  {
    desc = 'Open task markdown'
  }
)

cmd_user(
  'TaskMdNew',
  require('cmd.actions.task_md_new').task_md_new,
  {
    desc = 'Create new task markdown'
  }
)

cmd_user(
  'TaskBrowserTabs',
  require('cmd.actions.task_browser_tabs').task_browser_tabs,
  {
    desc = 'Open browser tabs related to task'
  }
)

cmd_user(
  'T',
  require('cmd.actions.trading_journal_new').trading_journal_new,
  {
    nargs = '*',
    desc = 'Create new trading journal note'
  }
)

-- @end create user commands
