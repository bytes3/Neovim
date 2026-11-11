vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- You can specify filetypes to autoformat on save here:
    local enabled_filetypes = {
      lua = true,
      -- python = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  -- You can also specify external formatters in here.
  formatters_by_ft = {
    lua = { 'stylua' },
    html = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    c = { 'clang-format' },
    python = { 'isort', 'black' },
    javascript = { 'biome' },
    typescript = { 'biome' },
    javascriptreact = { 'biome' },
    typescriptreact = { 'biome' },

    -- ['*'] = { 'codespell' },
    ['_'] = { 'trim_whitespace' },
  }
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end,
  { desc = '[F]ormat buffer' })
