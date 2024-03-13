return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      component_separators = '|',
      section_separators = '',
      theme = 'onedark',
    },
    tabline = {
      lualine_a = { 'buffers' },
    },
  },
}
