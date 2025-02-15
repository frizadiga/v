-- lazy loading recipes:
-- https://lazy.folke.io/spec/examples
-- https://lazy.folke.io/spec/lazy_loading
-- https://www.lazyvim.org/configuration/lazy.nvim -- yes it's a distro but it has some great tips

-- start bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      {('Failed to clone lazy.nvim:\n'),'ErrorMsg'},
      {out,'WarningMsg'},{'\nPress any key to exit...'}},
      true, {}
    )
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- end bootstrap lazy.nvim

-- vim options
require('_.opt') -- make sure loaded before lazy plugins setup

-- keybindings
require('_.key') -- make sure loaded before lazy plugins setup

-- lazy plugins setup
require('lazy').setup({
  spec = {
    { import = 'plug' }, -- load from dir /plugins
  },
  install = { colorscheme = { 'kanagawa-dragon' } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        -- 'matchit',
        -- 'matchparen',
      }, -- disabled not used rtp plug saves about couple ms on startup
    },
  },
  ui = {
    pills = false, size = { width = 1, height = 1 }, border = 'none',
  },
  defaults = {
    lazy = true, -- @NOTES: disabled auto lazy loading when shit happen 
  },
  -- see: https://github.com/folke/lazy.nvim/blob/main/lua/lazy/core/config.lua
})

-- auto commands
require('cmd.auto') -- not necessarily loaded before the lazy plugin setup

-- user commands
require('cmd.user') -- not necessarily loaded before the lazy plugin setup
