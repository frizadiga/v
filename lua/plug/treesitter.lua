return {
  {
    'folke/ts-comments.nvim',
    name = 'treesitter-comments',
    -- opts = {},
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- switch to the new main branch to get v0.12
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        -- v0.12 includes more parsers by default (C, Lua, Markdown, etc.)
        auto_install = true,
        highlight = {
          enable = true,
          -- opt: disable for large files to use v0.12's faster regex fallback
          disable = function(_, buf) -- arg1 is lang, arg2 is bufnr
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
      })
    end
  }
}
