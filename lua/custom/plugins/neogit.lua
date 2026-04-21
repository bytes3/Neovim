---@module 'lazy'
---@type LazySpec
return {
  'NeogitOrg/neogit',
  lazy = true,
  cmd = 'Neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
  },
  keys = {
    { '<leader>tg', '<cmd>Neogit<cr>', desc = 'Toggle [g]it' },
  },
  opts = {
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
  },
}
