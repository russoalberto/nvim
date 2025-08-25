return {
  'stevearc/conform.nvim',
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      cs = { 'csharpier' },
      htmlangular = { 'prettier' },
      lua = { 'stylua' },
      php = { 'php_cs_fixer' },
      typescript = { 'prettier' },
    },
  },
}
