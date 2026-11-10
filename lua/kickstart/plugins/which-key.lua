-- Useful plugin to show you pending keybinds.
vim.pack.add { 'https://github.com/folke/which-key.nvim' }

require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  plugins = {
    registers = true,
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
  },
  spec = {
    { '<leader>s', group = '[S]earch',                       mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk',                     mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { 'gr',        group = 'LSP Actions',                    mode = { 'n' } },
    { '<leader>o', group = '[o]pen file explorer' },
    { '<leader>a', group = '[a]dd buffer to Harpoon' },
    { '<leader>y', group = '[y]ank by system clipboard' },
    { '<leader>Y', group = '[Y]ank line to system clipboard' },
    { '<leader>h', group = '[h]unk Git menu',                mode = { 'n', 'v' } },
  },
}
