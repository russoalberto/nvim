return {
  {
    'numToStr/Navigator.nvim',
    keys = {
      { '<C-h>', '<Cmd>NavigatorLeft<CR>', desc = 'Navigate left' },
      { '<C-l>', '<Cmd>NavigatorRight<CR>', desc = 'Navigate right' },
      { '<C-j>', '<Cmd>NavigatorDown<CR>', desc = 'Navigate down' },
      { '<C-k>', '<Cmd>NavigatorUp<CR>', desc = 'Navigate up' },
    },
    config = function()
      require('Navigator').setup {}
    end,
  },
  {
    'OXY2DEV/markview.nvim',
    ft = { 'markdown' },
    opts = {
      preview = {
        filetypes = { 'md', 'markdown' },
        icon_provider = "mini",
        ignore_buftypes = {},
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      "saghen/blink.cmp",
    },
  },
}
