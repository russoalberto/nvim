local servers = {
  -- fontend
  angularls = {},
  astro = {},
  cssls = {},
  ts_ls = {},
  html = {
    settings = {
      html = {
        format = {
          tabSize = 2,
          insertSpace = true,
          wrapAttributesIndentSize = 2,
          wrapAttributes = 'preserve',
          wrapLineLength = 0,
        },
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
  clangd = {},
  ols = {},
  rust_analyzer = {},
  -- misc
  prismals = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        completion = { callSnippet = "Replace" },
      },
    },
  },
}

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
      -- Additional plugins for .net
      "iabdelkareem/csharp.nvim",
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
          local server_opts = servers[server_name] or {}
          table.insert(server_opts, { capabilities = capabilities })
          require('lspconfig')[server_name].setup(server_opts)
        end
      }
      -- Setup csharp
      require("csharp").setup({ dap = { enable = false } })
    end,
  },
}
