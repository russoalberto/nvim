return {
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function()
      require('gitsigns').setup {}
    end,
  },
  {
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
  },
  {
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
