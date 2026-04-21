return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    priority = 999,
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
      },

      -- Document existing key chains
      spec = {
        { '<leader>o', group = '[o]pen file explorer' },
        { '<leader>a', group = '[a]dd buffer to Harpoon' },
        { '<leader>y', group = '[y]ank by system clipboard' },
        { '<leader>Y', group = '[Y]ank line to system clipboard' },
        { '<leader>h', group = '[h]unk Git menu', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
}
