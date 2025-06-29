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
  omnisharp = {
    handlers = {
      ["textDocument/definition"] = function(...)
        return require("omnisharp_extended").handler(...)
      end,
      ["textDocument/typeDefinition"] = function(...)
        return require("omnisharp_extended").handler(...)
      end,
      ["textDocument/references"] = function(...)
        return require("omnisharp_extended").handler(...)
      end,
      ["textDocument/implementation"] = function(...)
        return require("omnisharp_extended").handler(...)
      end,
    },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    include_prerelease_sdks = true,
    enable_decompilation_support = true,
  },
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
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      -- Additional plugins for .net
      "Hoffs/omnisharp-extended-lsp.nvim",
    },
    config = function()
      -- Setup Mason
      require('mason').setup()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Ensure the servers above are installed
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
