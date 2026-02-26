return {
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup {}
    end,
    lazy = false,
  },
  {
    'OXY2DEV/markview.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      preview = {
        filetypes = { 'md', 'markdown', 'codecompanion' },
        ignore_buftypes = {},
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
