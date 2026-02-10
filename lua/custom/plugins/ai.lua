return {
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
      local neocodeium = require 'neocodeium'
      local cmds = require 'neocodeium.commands'

      -- for some reason, when using `:NeoCodium toggle`, it disables the plugin instead of enabling
      cmds.disable()

      neocodeium.setup {
        enabled = false,
        filter = function(bufnr)
          if vim.endswith(vim.api.nvim_buf_get_name(bufnr), '.env') then
            return false
          end
          return true
        end,
      }

      vim.keymap.set('i', '<A-l>', neocodeium.accept)
      vim.keymap.set('n', '<leader>ta', ':NeoCodeium toggle<CR>')
    end,
  },
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.g.opencode_opts = {
        provider = {
          enabled = 'tmux',
          tmux = {
            -- ...
          },
        },
      }
      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ 'n', 'x' }, '<leader>at', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode' })
      vim.keymap.set({ 'n' }, '<leader>ab', function()
        require('opencode').ask('@buffer: ', { submit = true })
      end, { desc = 'Ask opencode' })
      vim.keymap.set({ 'n', 'x' }, '<leader>aa', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 't' }, '<C-.>', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })

      vim.keymap.set({ 'n', 'x' }, 'go', function()
        return require('opencode').operator '@this '
      end, { expr = true, desc = 'Add range to opencode' })
      vim.keymap.set('n', 'goo', function()
        return require('opencode').operator '@this ' .. '_'
      end, { expr = true, desc = 'Add line to opencode' })

      vim.keymap.set('n', '<S-C-u>', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'opencode half page up' })
      vim.keymap.set('n', '<S-C-d>', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'opencode half page down' })
    end,
  },
}
