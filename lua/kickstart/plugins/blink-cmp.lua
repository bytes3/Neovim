vim.pack.add {
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/onsails/lspkind.nvim',
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/kristijanhusak/vim-dadbod-ui'
}

require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup {
  keymap = {
    preset = 'default',

    ['<Tab>'] = { 'fallback' },
    ['<S-Tab>'] = { 'fallback' },
    ['<C-l>'] = { 'snippet_forward' },
    ['<C-h>'] = { 'snippet_backward' },

    ['<C-r>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-g>'] = { 'scroll_documentation_down', 'fallback' },
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

      cmdline_position = function()
        if vim.g.ui_cmdline_pos ~= nil then
          local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
          return { pos[1] - 1, pos[2] }
        end
        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
        return { vim.o.lines - height, 0 }
      end,

      draw = {
        columns = {
          { 'kind_icon', 'label', gap = 1 },
          { 'kind' },
        },
        components = {
          kind_icon = {
            text = function(item)
              local kind = require('lspkind').symbol_map[item.kind] or ''
              return kind .. ' '
            end,
            highlight = 'CmpItemKind',
          },
          label = {
            text = function(item) return item.label end,
            highlight = 'CmpItemAbbr',
          },
          kind = {
            text = function(item) return item.kind end,
            highlight = 'CmpItemKind',
          },
        },
      },
    },
  },

  sources = {
    default = {
      'lsp',
      'path',
      'snippets',
      'buffer',
    },
    per_filetype = {
      sql = { 'dadbod', 'buffer', 'snippets' },
      plsql = { 'dadbod', 'buffer', 'snippets' },
      mysql = { 'dadbod', 'buffer', 'snippets' },
    },
    providers = {
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      path = {
        name = 'path',
        module = 'blink.cmp.sources.path',
        enabled = true,
        score_offset = 3,
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = function(ctx) return vim.fn.expand(('#%d:p:h').format(ctx.bufnr)) end,
          show_hidden_files_by_default = true,
        },
        should_show_items = true,
        fallbacks = { 'buffer' },
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
  -- See `:help blink-cmp-config-fuzzy` for more information
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
