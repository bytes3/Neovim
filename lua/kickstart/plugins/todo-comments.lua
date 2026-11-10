vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }

require('todo-comments').setup {
  signs = vim.g.have_nerd_font
}
