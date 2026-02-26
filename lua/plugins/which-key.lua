return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts =  {},
  config = function()
    require('which-key').add {
      { '<leader>a', group = '[A]I' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>g', group = '[G]it' },
      { '<leader>n', group = '[N]ote' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>z', group = '[Z]k notes' },
      { 'grn', desc = 'Code Re[n]ame' },
    }
  end,
}
