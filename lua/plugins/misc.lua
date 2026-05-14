return {
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
