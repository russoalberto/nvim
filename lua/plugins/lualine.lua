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
      lualine_a = { { 'buffers', max_length = function() return vim.go.columns end, } },
    },
  },
}
