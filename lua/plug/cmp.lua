return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  -- dependencies = 'rafamadriz/friendly-snippets',

  -- use a release tag to download pre-built binaries
  version = '*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- if you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- use `super-tab` preset with some customization (set explicitly for self-docs)
    keymap = {
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback'
      },
      ['<S-Tab>'] = { 'hide', 'fallback' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-d>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },

    cmdline = {
      keymap = {
        -- recommended, as the default keymap will only show and select the next item
        ['<Tab>'] = { 'show', 'accept' },
      },
      completion = { menu = { auto_show = true } },
    },

    appearance = {
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
    },

    sources = {
      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { 'sources.default' }
}
