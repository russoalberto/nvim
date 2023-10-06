return {
  {
    'folke/zen-mode.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    ops = {
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
