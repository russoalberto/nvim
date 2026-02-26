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
      { '<leader>a', group = '[A]vante AI' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>g', group = '[G]it' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
    })
  end,
}
