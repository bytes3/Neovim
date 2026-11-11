vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/JezerM/oil-lsp-diagnostics.nvim',
  'https://github.com/malewicz1337/oil-git.nvim',
}

require('oil').setup {
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['<C-p>'] = 'actions.open_external',
    ['<C-v>'] = 'actions.preview',
    ['yp'] = {
      desc = 'Copy filepath to system clipboard',
      callback = function()
        require('oil.actions').copy_entry_path.callback()
        vim.fn.setreg('+', vim.fn.getreg(vim.v.register))
      end,
    },
    ['yr'] = { -- Yank full file path
      callback = function()
        local oil = require 'oil'
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()

        if not entry or not dir then return end

        local relpath = vim.fn.fnamemodify(dir, ':.')

        vim.fn.setreg('+', relpath .. entry.name)
      end,
    },
  },
}

require('oil-git').setup {}
require('oil-lsp-diagnostics').setup {}
