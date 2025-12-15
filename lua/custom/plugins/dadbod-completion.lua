return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbout',
        callback = function()
          vim.wo.foldenable = false
        end,
      })

      vim.keymap.set('n', '<leader>td', '<CMD>tabnew | DBUI<CR>')
    end,
  },
}
