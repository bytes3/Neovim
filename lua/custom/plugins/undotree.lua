vim.pack.add { 'https://github.com/mbbill/undotree' }

vim.g.undotree_DiffAutoOpen = 0

vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = 'Toggle [u]ndotree' })
