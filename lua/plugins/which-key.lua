return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader>g'] = { name = '+Git' },
      ['<leader>s'] = { name = '+Search' },
      ['<leader>r'] = { name = '+Refactor' },
    },
  },
  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
