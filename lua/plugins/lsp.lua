local servers = {
  angularls = {},
  bashls = {},
  clangd = {},
  cssls = {},
  docker_compose_language_service = {},
  dockerls = {},
  html = {},
  intelephense = {},
  jsonls = {},
  lua_ls = {},
  marksman = {},
  omnisharp = {
    handlers = {
      ['textDocument/definition'] = function(...)
        return require('omnisharp_extended').handler(...)
      end,
      ['textDocument/typeDefinition'] = function(...)
        return require('omnisharp_extended').handler(...)
      end,
      ['textDocument/references'] = function(...)
        return require('omnisharp_extended').handler(...)
      end,
      ['textDocument/implementation'] = function(...)
        return require('omnisharp_extended').handler(...)
      end,
    },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    include_prerelease_sdks = true,
    enable_decompilation_support = true,
  },
  prismals = {},
  sqlls = {},
  tailwindcss = {},
  ts_ls = {},
  yamlls = {},
}

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      'Hoffs/omnisharp-extended-lsp.nvim',
    },
    config = function()
      require('mason').setup()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        automatic_installation = false,
        ensure_installed = vim.tbl_keys(servers),
      }
      for server, config in ipairs(servers) do
        table.insert(config, { capabilities = capabilities })
        require('lspconfig')[server].setup(config)
      end
    end,
  },
}
