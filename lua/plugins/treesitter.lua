return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  lazy = vim.fn.argc(-1) == 0,
  build = ':TSUpdate',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'astro',
        'bash',
        'c_sharp',
        'cpp',
        'dockerfile',
        'go',
        'html',
        'javascript',
        'json',
        'php',
        'prisma',
        'regex',
        'rust',
        'scss',
        'tsx',
        'typescript',
        'yaml',
      },
      highlight = {
        enable = true,
        disable = { "bigfile" },
      },
      indent = {
        enable = true,
        disable = { "bigfile" },
      }
    }
  end,
}
