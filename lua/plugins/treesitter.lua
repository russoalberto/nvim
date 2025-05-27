return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ensureInstalled = {
        'angular',
        'astro',
        'bash',
        'c',
        'cmake',
        'c_sharp',
        'cpp',
        'dockerfile',
        'go',
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
      local alreadyInstalled = require("nvim-treesitter.config").installed_parsers()
      local parsersToInstall = vim.iter(ensureInstalled)
          :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
          :totable()
      require("nvim-treesitter").install(parsersToInstall)

      -- start parsers for filetypes
      for _, parser in pairs(ensureInstalled) do
        local filetypes = vim.treesitter.language.get_filetypes(parser)

        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = filetypes,
          callback = function()
            vim.treesitter.start()
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end
    end
  }
}
