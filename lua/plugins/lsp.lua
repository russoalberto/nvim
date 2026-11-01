local servers = {
  angularls = {},
  bashls = {},
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
  sqls = {},
  tailwindcss = {},
  tofu_ls = {
    root_dir = function(bufnr, on_dir)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local root = vim.fs.root(bufnr, { '.git', '.terraform', 'terraform.tf' })
      on_dir(root or vim.fs.dirname(name))
    end,
  },
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
      { 'j-hui/fidget.nvim', tag = 'v2.0.0', opts = {} },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            'blink.cmp',
            'lazy.nvim',
          },
        },
      },
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
