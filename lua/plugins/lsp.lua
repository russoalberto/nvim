local servers = {
  angularls = {},
  astro = {},
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
  prismals = {},
  sqlls = {},
  tailwindcss = {},
  terraformls = {},
  ts_ls = {},
  yamlls = {},
}

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            'blink.cmp',
            'lazy.nvim',
            'nvim-dap-ui',
          },
        },
      },
      'GustavEikaas/easy-dotnet.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('mason').setup()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        automatic_installation = false,
        ensure_installed = vim.tbl_keys(servers),
      }
      require('easy-dotnet').setup {
        lsp = {
          enabled = true,
          preload_roslyn = true,
          -- This enables the specific Roslyn analyzers you asked for
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          -- Matches your 'enable_import_completion' request
          capabilities = {
            definitionProvider = true,
            referencesProvider = true,
          },
          -- Passing your requested settings to the server
          settings = {
            ['dotnet|roslyn'] = {
              enable_roslyn_analyzers = true,
              organize_imports_on_format = true,
              enable_import_completion = true,
              include_prerelease_sdks = true,
              enable_decompilation_support = true,
            },
          },
        },
      }
      for server, config in ipairs(servers) do
        table.insert(config, { capabilities = capabilities })
        require('lspconfig')[server].setup(config)
      end
    end,
  },
}
