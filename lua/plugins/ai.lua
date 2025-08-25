return {
  'olimorris/codecompanion.nvim',
  opts = {
    strategies = {
      chat = {
        adapter = 'gemini',
      },
      inline = {
        adapter = 'gemini',
        keymaps = {
          accept_change = {
            modes = { n = 'gra' },
            description = '[A]ccept the suggested change',
          },
          reject_change = {
            modes = { n = 'grj' },
            description = 'Re[j]ect the suggested change',
          },
        },
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
