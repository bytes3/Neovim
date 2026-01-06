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
}
