return {
  'stevearc/oil.nvim',
  event = 'VeryLazy',
  config = function()
    local oil = require('oil')
    local state_detail = false
    local copy_to_clip = require'shared.clipboard'.copy_to_clip

    local keymaps = {
      -- act as enter key
      -- cater memory muscle slip
      [';'] = {
        'actions.select',
        desc = 'Oil: Open file or directory',
      },
      ['L'] = {
        'actions.select',
        desc = 'Oil: Open file or directory',
      },
      -- to cater specific muscle memory case
      ['<Esc>'] = {
        desc = 'Oil: Close oil',
        callback = oil.close,
      },
      ['H'] = {
        'actions.parent',
        desc = 'Oil: Up one directory',
      },
      ['gd'] = {
        desc = 'Oil: Toggle file detail view',
        callback = function()
          state_detail = not state_detail
          if state_detail then
            oil.set_columns({
              'icon',
              'permissions',
              'size',
              'mtime'
            })
          else
            oil.set_columns({ 'icon' })
          end
        end,
      },
      ['gs'] = {
        desc = 'Oil: Search in directory via Grug',
        callback = function()
          local prefills = { paths = oil.get_current_dir() }

          local grug = require 'grug-far'
          if grug.has_instance 'explorer' then
            grug.open_instance 'explorer'
            -- updating the prefills without clearing the search and other fields
            grug.update_instance_prefills('explorer', prefills, false)
          else
            grug.open {
              instanceName = 'explorer',
              prefills = prefills,
              staticTitle = 'Find and Replace from Explorer',
              windowCreationCommand = 'new', -- must be `new` to prevent opening in oil buffer
            }
          end
        end,
      },
      ['gf'] = {
        desc = 'Oil: Live grep in current working directory via Telescope',
        callback = function()
          local path = oil.get_current_dir()
          oil.close() -- need to close oil to prevent result from opening in oil buffer
          require('telescope.builtin').live_grep({ prompt_title = 'Live Grep - CWD', cwd = path })
        end,
      },
      ['gcp'] = {
        desc = 'Oil: Copy path (file or directory)',
        callback = function()
          local entry = oil.get_cursor_entry()
          local dir_path = oil.get_current_dir()
          -- @NOTE: rm trailing `/..` if it's a directory
          copy_to_clip((dir_path .. entry.name):gsub('/%..$', ''))
        end,
      },
      ['gcr'] = {
        desc = 'Oil: Copy file remote url',
        callback = function()
          local entry = oil.get_cursor_entry()
          local dir_path = oil.get_current_dir()
          -- @NOTE: rm trailing `/..` if it's a directory
          local final_path = (dir_path .. entry.name):gsub('/%..$', '')

          if vim.fn.filereadable(final_path) ~= 1 then
            vim.notify('Not a file!', vim.log.levels.ERROR, { title = 'Oil' })
            return
          end

          copy_to_clip(require 'shared.git_remote_url'
            .get_git_remote_url({ file_path = final_path, with_line_numbers = false }))
        end,
      },
    }

    local def_opt = {
      keymaps = keymaps,
      columns = { 'icon' }, -- see :help oil-columns
      view_options = {
        -- show files and directories that start with '.'
        show_hidden = true,
        -- this function defines what is considered a 'hidden' file
        is_hidden_file = function(name)
          return vim.startswith(name, '.')
        end,
      },
      preview = {
        win_options = {
          winhl = 'Normal:Normal,Float:Float',
        },
      },
      float = {
        padding = 2,
        max_width = 50,
        max_height = 20,
        border = 'rounded',
        -- make title empty to disable the title
        get_win_title = function() return '' end,
      },
      skip_confirm_for_simple_edits = true,
      default_file_explorer = false, -- prevent oil startup screen passing `false` is required
    }

    oil.setup(def_opt)

    -- open floating window
    vim.keymap.set('n', '<leader>e', oil.toggle_float, { desc = 'Open Oil in current buffer dir' })

    -- open `oil` with path was opened with `nvim .`
    vim.keymap.set('n', '<leader>E', '<CMD>Oil --float .<CR>', { desc = 'Open Oil in root project path' })
  end,
}
