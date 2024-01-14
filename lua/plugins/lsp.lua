local servers = {
  -- fontend
  angularls = {},
  cssls = {},
  tsserver = {},
  html = {
    html = {
      format = {
        tabSize = 2,
        useTabs = false,
        wrapAttributesIndentSize = 2,
        wrapAttributes = 'preserve',
        wrapLineLength = 0,
      },
    },
  },
  tailwindcss = {},

  -- backend
  intelephense = {},
  gopls = {},
  omnisharp = {},
  sqlls = {},
  -- fileconfig
  dockerls = {},
  docker_compose_language_service = {},
  yamlls = {},
  jsonls = {},
  marksman = {},
  -- system
  bashls = {},
  rust_analyzer = {},
  -- misc
  grammarly = {},
  prismals = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
    config = function()
      -- Setup neovim lua configuration
      require('neodev').setup()

      -- Setup Mason
      require('mason').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            settings = (servers[server_name] or {}),
          }
        end,
      }
    end,
  },
}
