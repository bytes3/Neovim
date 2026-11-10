-- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
--
-- See `:help gitsigns` to understand what each configuration key does.
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/purarue/gitsigns-yadm.nvim'
}
local gitsigns = require 'gitsigns'

gitsigns.setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  _on_attach_pre = function(bufnr, callback)
    if vim.fn.executable("yadm") == 1 then
      require("gitsigns-yadm").yadm_signs(callback, { bufnr = bufnr })
    else
      -- if optionally disabling the plugin, make sure to call
      -- 'callback' with no arguments
      callback()
    end
  end,
  -- gitsigns.nvim's recommended keymaps:
  on_attach = function(buffer)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = buffer
      vim.keymap.set(mode, l, r, opts)
    end

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
      { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
      { desc = 'git [r]eset hunk' })
    -- normal mode
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'git [D]iff against last commit', buf = bufnr })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline', buf = bufnr })
    map('n', '<leader>n', function() gitsigns.nav_hunk('next', { preview = true, greedy = false }) end,
      { desc = 'git [n]ext hunk' })
    map('n', '<leader>N', function() gitsigns.nav_hunk('prev', { preview = true, greedy = false }) end,
      { desc = 'git [N] previous hunk' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[t]oggle git show [b]lame line' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[t]oggle git intra-line [w]ord diff' })
  end,
}
