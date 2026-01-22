return {
  {
    -- treesitter based
    'folke/ts-comments.nvim',
    name = 'treesitter-comments',
    opts = {},
    event = 'VeryLazy',
    -- nowadays v0.10.0 is minimum requirement
    -- enabled = vim.fn.has('nvim-0.10.0') == 1,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        -- context_commentstring = { enable = true, enable_autocmd = false },
      })
    end
  }
}
