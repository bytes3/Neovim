---@module 'lazy'
---@type LazySpec
return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*', -- Latest stable release
    config = function()
      vim.o.autoread = true -- Required for `opts.events.reload`

      vim.keymap.set({ 'n', 'x' }, '<leader>at', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 't' }, '<leader>ta', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })

      vim.keymap.set('n', '<S-C-u>', function() require('opencode').command 'session.half.page.up' end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<S-C-d>', function() require('opencode').command 'session.half.page.down' end, { desc = 'Scroll opencode down' })
    end,
  },
}
