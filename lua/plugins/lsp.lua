local servers = {
  angularls = {},
  astro = {},
  bashls = {},
  clangd = {},
  cssls = {},
  docker_compose_language_service = {},
  dockerls = {},
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
  intelephense = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            '${3rd}/luv/library',
          },
        },
      },
    },
  },
  marksman = {},
  prismals = {},
  sqlls = {},
  tailwindcss = {},
  tofu_ls = {},
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'none',
          includeInlayEnumMemberValueHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
        },
        tsserver = {
          maxTsServerMemory = 8192,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'none',
          includeInlayEnumMemberValueHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
        },
      },
    },
  },
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

      local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

      -- mason-lspconfig: install ensured servers, disable auto-enable.
      -- We handle server setup directly via lspconfig.setup() below.
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      }

      -- Set up each server with blink.cmp capabilities + custom settings
      -- Uses vim.lsp.config (nvim-lspconfig v3+ API) instead of deprecated require('lspconfig')[name].setup()
      for server_name, server_opts in pairs(servers) do
        local opts = vim.deepcopy(server_opts)
        opts.capabilities = blink_capabilities
        vim.lsp.config(server_name, opts)
        vim.lsp.enable(server_name)
      end

      require('easy-dotnet').setup {
        lsp = {
          enabled = true,
          preload_roslyn = true,
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          capabilities = {
            definitionProvider = true,
            referencesProvider = true,
          },
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

      vim.diagnostic.config {
        virtual_text = false,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },
      }
    end,
  },
}
