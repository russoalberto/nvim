return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function()
    require('which-key').add {
      { '<leader>a', group = '[A]I' },
      { '<leader>g', group = '[G]it' },
      { '<leader>s', group = '[S]earch' },
      { 'gr', desc = '[R]efactor' },
      { 'grn', desc = 'Code Re[n]ame' },
    }
  end,
}
