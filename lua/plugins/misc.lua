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
