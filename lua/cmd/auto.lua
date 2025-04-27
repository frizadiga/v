-- @start_section fmt-lang-config
-- @NOTE: this configs are LSP-independent

local cmd_auto = vim.api.nvim_create_autocmd

cmd_auto('FileType', {
  pattern = 'c,cpp',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
    -- @NOTE: the .clang-format file uses LLVM's coding style
  end,
})

cmd_auto('FileType', {
  pattern = 'zig',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
  end,
})

cmd_auto('FileType', {
  pattern = 'rust',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'mojo,🔥',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'lua',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'sh,zsh,bash',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

cmd_auto('FileType', {
  pattern = 'javascript,typescript,javascriptreact,typescriptreact',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*/nginx/*"},
  -- pattern = {"*/nginx/*.conf", "*/etc/nginx/*", "nginx.conf"},
  callback = function() vim.bo.filetype = "nginx" end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nginx",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end
})
-- @end_section fmt-lang-config
