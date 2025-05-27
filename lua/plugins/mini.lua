return {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.ai').setup()
      require('mini.diff').setup()
      require('mini.git').setup()
      require('mini.icons').setup()
      require('mini.statusline').setup()
      require('mini.surround').setup()
    end,
  }
