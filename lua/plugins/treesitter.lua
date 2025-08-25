local ensureInstalled = {
  'angular',
  'astro',
  'bash',
  'c',
  'c_sharp',
  'cmake',
  'cpp',
  'dockerfile',
  'go',
  'hcl',
  'html',
  'hyprlang',
  'javascript',
  'json',
  'julia',
  'odin',
  'php',
  'php_only',
  'phpdoc',
  'prisma',
  'regex',
  'rust',
  'scss',
  'sql',
  'tsx',
  'twig',
  'typescript',
  'yaml',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local alreadyInstalled = require('nvim-treesitter.config').get_installed 'parsers'
    local parsersToInstall = vim
      .iter(ensureInstalled)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    require('nvim-treesitter').install(parsersToInstall)

    local parsersInstalled = require('nvim-treesitter.config').get_installed 'parsers'
    for _, parser in pairs(parsersInstalled) do
      local filetypes = vim.treesitter.language.get_filetypes(parser)

      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end
  end,
}
