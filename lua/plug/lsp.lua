return {
  {
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    config = function()
      require('mason').setup({
        ui = {
          width = 1,
          height = 1,
          border = 'none',
          check_outdated_packages_on_open = true,
        },
        ensure_installed = { 'eslint_d' },
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = 'VeryLazy',
    opts = {
      auto_install = true,
      ensure_installed = {
        'bashls',
        'powershell_es',
        -- 'clangd', -- exluded to use native binary
        'zls',
        'gopls',
        'html',
        'ts_ls',
        'jsonls',
        'taplo',
        'yamlls',
        'lua_ls',
        'pyright',
        'rust_analyzer',
        'nginx_language_server',
        'solidity_ls_nomicfoundation',
        -- 'mojo-lsp-server', -- for now manually install, isn't avail via mason yet
      },
      servers = {
        clangd = {
          mason = false, -- using native binary instead
        },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = function()
      local lspconfig_util = require 'lspconfig.util'
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local get_git_root = function(fname)
        return lspconfig_util.root_pattern '.git' (fname)
      end

      -- set default capabilities for all servers
      vim.lsp.config['*'] = { capabilities = capabilities }

      -- configure servers that need custom settings
      vim.lsp.config.ts_ls = { root_dir = get_git_root }
      vim.lsp.config.eslint = { root_dir = get_git_root }
      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.fn.expand('$VIMRUNTIME/lua'),
                vim.fn.stdpath('config') .. '/lua'
              }
            },
            format = { enable = true },
          }
        },
      }
      vim.lsp.config.nginx_language_server = {
        cmd = { 'nginx-language-server' },
        filetypes = { 'nginx' },
        root_dir = get_git_root,
        settings = {
          nginx = {
            format = {
              enable = true,
            }
          }
        }
      }
      vim.lsp.config.yamlls = { filetypes = { 'yml', 'yaml' } }
      vim.lsp.config.solidity_ls_nomicfoundation = {
        cmd = {
          vim.fn.stdpath("data") .. "/mason/bin/nomicfoundation-solidity-language-server",
          "--stdio"
        },
        filetypes = { 'solidity', 'sol' },
        root_dir = get_git_root,
      }
      -- TODO: enable when mojo-lsp-server is available via mason or use clangd approach
      -- vim.lsp.config.mojo = { cmd = { 'mojo-lsp-server' }, filetypes = { 'mojo', '🔥' } }

      local servers = {
        'clangd',
        'zls',
        'rust_analyzer',
        'bashls',
        'gopls',
        'ts_ls',
        'eslint',
        'jsonls',
        'taplo',
        'yamlls',
        'html',
        'pyright',
        'lua_ls',
        'mojo',
        'nginx_language_server',
        'solidity_ls_nomicfoundation',
      }

      -- enable all configured servers
      vim.lsp.enable(servers)

      -- buffer-specific LSP keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover' })
      vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'LSP: Do Format - Current Buffer' })
      vim.keymap.set('x', '<leader>lf', vim.lsp.buf.format, { desc = 'LSP: Do Format - Selected Visual Text' })
      vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, { desc = 'LSP: Do Rename' })
      vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, { desc = 'LSP: Go to Definition' })
      vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, { desc = 'LSP: Go to Declaration' })
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, { desc = 'LSP: Go to References' })
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'LSP: Select Code Action' })
      vim.keymap.set('n', '<leader>lc', vim.diagnostic.reset,
        { desc = 'LSP: Clear all Diagnostics in the current buffer' })
    end,
  },
}
