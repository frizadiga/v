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
        -- 'powershell_es', -- disabled until runaway pwsh process issue is resolved
        -- 'clangd', -- exluded to use native binary
        'zls',
        'gopls',
        'html',
        'vtsls',
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
      local vtsls_lang_opts = {
        inlayHints = {
          variableTypes = { enabled = true },
          parameterTypes = { enabled = true },
          parameterNames = { enabled = 'all' },
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
        },
        updateImportsOnFileMove = { enabled = 'prompt' },
      }
      vim.lsp.config.vtsls = {
        settings = {
          javascript = vtsls_lang_opts,
          typescript = vtsls_lang_opts,
          vtsls = {
            autoUseWorkspaceTsdk = true, -- use workspace TS version
            -- maxTsServerMemory = 5120, -- only if open shitty large monorepo
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
        }
      }
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
      -- disabled for now until issue with runaway pwsh process is resolved
      -- native Linux pwsh required: pwsh.exe blocked by Group Policy on WSL UNC paths.
      -- local mason_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services'
      -- local pwsh_bin = vim.fn.expand('~/.local/share/pwsh/pwsh')
      -- vim.lsp.config.powershell_es = {
      --   cmd = {
      --     pwsh_bin, '-NoLogo', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command',
      --     string.format(
      --       "& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s' -SessionDetailsPath '%s' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal",
      --       mason_path, mason_path,
      --       vim.fn.stdpath('cache') .. '/powershell_es.log',
      --       vim.fn.stdpath('cache') .. '/powershell_es.session.json'
      --     )
      --   },
      --   cmd_env = { DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = '1' },
      --   filetypes = { 'ps1', 'psm1', 'psd1' },
      -- }
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
        'vtsls',
        'eslint',
        'jsonls',
        'taplo',
        'yamlls',
        'html',
        'pyright',
        'lua_ls',
        'mojo',
        -- 'powershell_es', -- disabled until runaway pwsh process issue is resolved
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
