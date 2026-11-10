vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dbout',
  callback = function() vim.wo.foldenable = false end,
})
