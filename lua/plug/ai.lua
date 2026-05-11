return {
  {
    "ggml-org/llama.vim",
    name = 'ai-completions',
    event = 'VeryLazy', -- load on idle time (after UIEnter)
    init = function()
      vim.g.llama_config = {
        auto_fim               = true,
        n_predict              = 128,
        t_max_predict_ms       = 3500,

        keymap_fim_accept_full = "<Tab>",
        keymap_fim_trigger     = "<C-l>f",
        keymap_fim_accept_line = "<S-Tab>",
        keymap_fim_accept_word = "<C-l>]",
        keymap_inst_trigger    = "<C-l>i",
        keymap_inst_retry      = "<C-l>r",
        keymap_inst_continue   = "<C-l>c",

        endpoint_fim           = os.getenv("LLAMACPP_TOKEN_FACTORY_INFILL_EP"),
        show_info              = 2, -- 2 = inline info (speed/tokens); 1 = statusline; 0 = off
      }
    end
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    name = 'ai-chat',
    event = 'VeryLazy',      -- load on idle time (after UIEnter)
    branch = 'main',
    build = 'make tiktoken', -- only on MacOS or Linux
    config = function()
      local cc = require 'CopilotChat'
      local ollama_model = os.getenv("OLLAMA_CHAT_MODEL")
      local ollama_endpoint = os.getenv("OLLAMA_TOKEN_FACTORY_URL_CHAT")

      local def_win_opt = {
        title = '',
        layout = 'float',
        relative = 'editor',
        border = 'single',
        width = 80,
        height = 15,
      }

      cc.setup({
        debug = false,
        error_header = 'Err',
        answer_header = '▶︎ A',
        question_header = '▶︎ Q',
        -- separator = '',
        window = def_win_opt,
        mappings = {
          submit_prompt = {
            normal = '<CR>',
            insert = '<C-;>',
          },
          accept_diff = {
            normal = '<Space><Space>',
          },
          reset = {
            normal = '<C-l>', insert = '<C-l>', },
          complete = {
            insert = '<S-Tab>', -- prevent conflict with copilot ghost suggestion
            detail = 'Use @<Tab> or /<Tab> for options.',
            -- https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/324#issuecomment-2118551487
          },
        },
        -- Use Ollama via an OpenAI-compatible endpoint instead of Copilot.
        -- The provider is auto-selected based on which provider's get_models()
        -- exposes the chosen `model` id; we also disable the default copilot
        -- provider so it can't claim a model id collision.
        -- Ref: https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/main/lua/CopilotChat/config/providers.lua
        providers = {
          copilot = { disabled = true },
          github_models = { disabled = true },
          ollama = {
            prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
            prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,
            get_models = function(headers)
              local base = ollama_endpoint:gsub('/chat/completions$', ''):gsub('/v1$', '')
              local response, err = require('CopilotChat.utils.curl').get(base .. '/v1/models', {
                headers = headers,
                json_response = true,
              })
              if err then error(err) end
              return vim.tbl_map(function(m)
                return { id = m.id, name = m.id, streaming = true, tools = false }
              end, (response.body or {}).data or {})
            end,
            get_url = function() return ollama_endpoint end,
          },
        },
        model = ollama_model, -- can be specified manually in prompt via $
        context = nil,        -- default context or array of contexts to use (can be specified manually in prompt via #).
        temperature = 0.1,    -- LLM result temperature (0.0 - 1.0) closer to 0 is more deterministic, closer to 1 is more "creative".
        prompts = {
          -- handle non latin languages
          TransToEn = {
            mapping = '<leader>ccl',
            prompt = ' Translate the following text to English:',
            system_prompt =
            'You are an expert language translator specializing in accurate translations to English. Preserve the original meaning, tone, and cultural nuances while providing natural, fluent English translations. For idioms or culturally-specific expressions, include brief explanations when necessary.',
          },
        },
        -- default config see: https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/config.lua#L81
      })

      -- file-type handler for 'copilot-chat'
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })

      -- show chat window
      vim.keymap.set({ 'n', 'v' }, '<leader>ccc', cc.open)

      -- show chat window with fix instructions
      vim.keymap.set('v', '<leader>ccf', '<CMD>CopilotChatFix<CR>')

      -- show chat window with review instructions
      vim.keymap.set('v', '<leader>ccr', '<CMD>CopilotChatReview<CR>')

      -- show chat window with explain instructions
      vim.keymap.set('v', '<leader>cce', '<CMD>CopilotChatExplain<CR>')

      -- select model
      vim.keymap.set('n', '<leader>ccm', '<CMD>CopilotChatModels<CR>')

      -- show current model
      vim.keymap.set('n', '<leader>ccM', function() vim.notify(cc.config.model) end)

      local max_win_opt = vim.tbl_extend('force', def_win_opt, {
        width = 1.0,
        height = 1.0,
        border = 'none',
      })

      -- show max chat window
      vim.keymap.set({ 'n', 'v' }, '<leader>ccC', function() cc.open { window = max_win_opt } end)

      -- impl more: https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file#commands-coming-from-default-prompts
    end,
  },
}
