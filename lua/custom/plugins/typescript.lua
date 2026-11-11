vim.pack.add {
  'https://github.com/dmmulroy/tsc.nvim',
  'https://github.com/dmmulroy/ts-error-translator.nvim',
}

require('tsc').setup {
  run_as_monorepo = true,
}

require('ts-error-translator').setup {
  -- Auto-attach to LSP servers for TypeScript diagnostics (default: true)
  auto_attach = true,

  -- LSP server names to translate diagnostics for (default shown below)
  servers = {
    'astro',
    'svelte',
    'ts_ls',
    'typescript-tools',
    'volar',
    'vtsls',
  },
}
