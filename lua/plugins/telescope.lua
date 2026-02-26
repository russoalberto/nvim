return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension 'fzf'
      end,
    },
    -- change some options
    opts = {
      defaults = {
        hidden = true,
        path_display = {
          shorten = {
            len = 3,
            exclude = { 1, -1 },
          },
          truncate = true,
        },
      },
    },
  },
}
