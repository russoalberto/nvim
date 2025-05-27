return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = { spelling = true },
  },
  config = function(_, opts)
    require('which-key').setup(opts)
    require("which-key").add({
      -- Group
      { '<leader>a', group = '[A]I' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>g', group = '[G]it' },
      { '<leader>n', group = '[N]ote' },
      { '<leader>q', group = '[Q]uit' },
      { '<leader>s', group = '[S]earch' },
      -- Desc
      { 'grn',       desc = 'Code Re[n]ame' },
      { 'gra',       desc = 'Code [A]ction' },
      { 'grc',       desc = 'Code Do[c]umentation' }
    })
  end,
}
