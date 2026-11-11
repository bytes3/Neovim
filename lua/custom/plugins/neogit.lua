vim.pack.add {
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/sindrets/diffview.nvim',
}

require('diffview').setup {}

require('neogit').setup {
  treesitter_diff_highlight = true,
  -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
  -- sorter instead. By default, this function returns `nil`.
  telescope_sorter = function() return require('telescope').extensions.fzf.native_fzf_sorter() end,
  integrations = {
    telescope = true,
    diffview = true,
  },
  diff_viewer = 'diffview',
  mappings = {
    commit_editor = {
      ['<leader>N'] = 'PrevMessage',
      ['<leader>n'] = 'NextMessage',
    },
  },
}

vim.keymap.set('n', '<leader>tg', '<cmd>Neogit<cr>', { desc = 'Toggle [g]it' })
