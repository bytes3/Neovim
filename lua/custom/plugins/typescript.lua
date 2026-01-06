return {
  'dmmulroy/tsc.nvim',
  -- cond=false,
  config = function()
    require('tsc').setup {
      run_as_monorepo = true,
    }
  end,
}
