return {
  {
    'folke/zen-mode.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      window = {
        width = 140,
        options = {
          number = true,
          relativenumber = true,
        },
      },
    },
  },
}
