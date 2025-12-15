-- TODO: Add snippits for other language
return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    priority = 994,
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      'alexandre-abrioux/blink-cmp-npm.nvim',
      'mgalliou/blink-cmp-tmux',
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
        ['<C-r>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-g>'] = { 'scroll_documentation_down', 'fallback' },

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
          },
        },
        menu = {
          border = 'rounded',
          winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
        },
      },

      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'lazydev',
          'buffer',
          'tmux',
          'npm',
        },
        per_filetype = {
          sql = { 'dadbod', 'tmux', 'buffer', 'snippets' },
          plsql = { 'dadbod', 'tmux', 'buffer', 'snippets' },
          mysql = { 'dadbod', 'tmux', 'buffer', 'snippets' },
        },
        providers = {
          -- path = {
          --   module = 'blink.cmp.sources.path',
          --   score_offset = 3,
          --   opts = {
          --     -- took from :help blink-cmp-mode-specific-configurations
          --     trailing_slash = true,
          --     label_trailing_slash = true,
          --     get_cwd = function(context)
          --       return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
          --     end,
          --     show_hidden_files_by_default = true,
          --     -- Treat `/path` as starting from the current working directory (cwd) instead of the root of your filesystem
          --     ignore_root_slash = false,
          --   },
          -- },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
          npm = {
            name = 'npm',
            module = 'blink-cmp-npm',
            async = true,
            -- optional - make blink-cmp-npm completions top priority (see `:h blink.cmp`)
            score_offset = 100,
            -- optional - blink-cmp-npm config
            ---@module "blink-cmp-npm"
            ---@type blink-cmp-npm.Options
            opts = {
              ignore = {},
              only_semantic_versions = true,
              only_latest_version = false,
            },
          },
          tmux = {
            module = 'blink-cmp-tmux',
            name = 'tmux',
            -- default options
            opts = {
              all_panes = false,
              capture_history = false,
              -- only suggest completions from `tmux` if the `trigger_chars` are
              -- used
              triggered_only = false,
              trigger_chars = { '.' },
            },
          },
        },

        -- Minimum number of characters in the keyword to trigger all providers
        -- May also be `function(ctx: blink.cmp.Context): number`
        min_keyword_length = 0,
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
