# Neovim LSP Performance Update — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce LSP completion latency from ~2s to <800ms by fixing ipairs bug, tuning server configs, lazy-loading treesitter, and cleaning up plugin specs.

**Architecture:** Fix `lsp.lua` to use `mason-lspconfig` handlers (replaces broken `ipairs` loop). Tune `treesitter.lua` for lazy load + remove redundant autocommands. Add per-server performance settings. Minor tuning to blink.cmp, misc plugins, and lazy.nvim bootstrap.

**Tech Stack:** Neovim 0.12, lazy.nvim, blink.cmp v1, nvim-lspconfig, mason, nvim-treesitter

---

### Task 1: Fix LSP configuration — handler pattern + server tuning

**Files:**
- Modify: `lua/plugins/lsp.lua` (entire file)

- [ ] **Step 1: Replace lsp.lua with proper handler pattern**

The current file uses `ipairs(servers)` which never iterates a dict. Replace entirely.

Current file (`lua/plugins/lsp.lua`):
```lua
local servers = {
  angularls = {},
  astro = {},
  bashls = {},
  clangd = {},
  cssls = {},
  docker_compose_language_service = {},
  dockerls = {},
  html = { ... },
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
    dependencies = { ... },
    config = function()
      require('mason').setup()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        automatic_installation = false,
        ensure_installed = vim.tbl_keys(servers),
      }
      require('easy-dotnet').setup { ... }
      for server, config in ipairs(servers) do
        table.insert(config, { capabilities = capabilities })
        require('lspconfig')[server].setup(config)
      end
    end,
  },
}
```

Replace with:
```lua
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
  terraformls = {
    settings = {
      terraform = {
        experimentalFeatures = {
          prefillRequiredFields = true,
        },
      },
    },
  },
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'none',
          includeInlayEnumMemberValueHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
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

      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server_config = vim.deepcopy(servers[server_name]) or {}
            server_config.capabilities = blink_capabilities
            require('lspconfig')[server_name].setup(server_config)
          end,
        },
      }

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
    end,
  },
}
```

- [ ] **Step 2: Add vim.diagnostic.config() at end of config function**

Append to the `config = function()` body, before the closing `end`:

```lua
      vim.diagnostic.config {
        virtual_text = false,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },
      }
```

- [ ] **Step 3: Verify LSP starts correctly**

Open a TypeScript file in a project, run:
```
:LspInfo
```
Expected: ts_ls shows as attached, capabilities section shows `completion` provider.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "fix(lsp): use mason-lspconfig handlers, add server tunings and diagnostic config"
```

---

### Task 2: Fix treesitter — lazy load + remove redundant autocommands

**Files:**
- Modify: `lua/plugins/treesitter.lua` (entire file)

- [ ] **Step 1: Replace treesitter.lua with lazy-loading version**

Current file:
```lua
local ensureInstalled = { ... 29 parsers ... }

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
```

Replace with:
```lua
local ensure_installed = {
  'angular',
  'astro',
  'bash',
  'c',
  'c_sharp',
  'caddy',
  'dockerfile',
  'hcl',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'php',
  'prisma',
  'regex',
  'scss',
  'sql',
  'terraform',
  'tsx',
  'twig',
  'typescript',
  'yaml',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  event = { 'BufReadPost', 'BufNewFile' },
  build = false,
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = ensure_installed,
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      fold = { enable = true },
    }

    -- Deferred auto-install: don't block first buffer render
    vim.defer_fn(function()
      local ok, installed = pcall(vim.treesitter.list_parsers)
      if not ok then return end
      local to_install = {}
      for _, parser in ipairs(ensure_installed) do
        if not vim.list_contains(installed, parser) then
          to_install[#to_install + 1] = parser
        end
      end
      if #to_install > 0 then
        vim.cmd('TSInstall ' .. table.concat(to_install, ' '))
      end
    end, 200)
  end,
}
```

Key changes:
- `lazy = false` → `event = { 'BufReadPost', 'BufNewFile' }`
- `build = ':TSUpdate'` → `build = false`
- Entire `for _, parser in pairs(...)` autocommand loop removed (treesitter auto-attaches)
- `configs.setup()` with `highlight`, `indent`, `fold` handles everything
- `vim.defer_fn(200)` defers auto-install so first buffer renders immediately
- `pcall` guards against nil return from list_parsers (edge case)

- [ ] **Step 2: Verify treesitter loads on open**

Open a TypeScript file:
```
:TSModuleInfo
```
Expected: parsers for typescript/tsx show as active. Highlighting and indentation work.

- [ ] **Step 3: Restart neovim, check startup time**

```bash
nvim --startuptime /tmp/nvim-startup.log +q
grep -E 'startup|treesitter' /tmp/nvim-startup.log
```

Expected: treesitter NOT in startup log (lazy loaded).

- [ ] **Step 4: Verify folding and indentation still work**

Open a TypeScript file, type `za` on a function. Expected: folds correctly.
Indent a new line. Expected: correct indentation.

- [ ] **Step 5: Commit**

```bash
git add lua/plugins/treesitter.lua
git commit -m "fix(treesitter): lazy load, remove redundant autocommands, use configs.setup()"
```

---

### Task 3: Tune blink.cmp — add min_keyword_length

**Files:**
- Modify: `lua/plugins/cmp.lua` (one line addition)

- [ ] **Step 1: Add min_keyword_length = 2 to blink.cmp opts**

In `lua/plugins/cmp.lua`, add one line inside `opts.completion`:

Find:
```lua
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
```

Replace with:
```lua
    completion = {
      min_keyword_length = 2,
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
```

- [ ] **Step 2: Verify completion still triggers on 2+ chars**

Open a TypeScript file, type `co`. Expected: completion popup shows.
Type `c`. Expected: no popup (below threshold).

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/cmp.lua
git commit -m "perf(cmp): set min_keyword_length=2 to reduce LSP queries"
```

---

### Task 4: Fix plugin lazy-loading — Navigator, markview, mini

**Files:**
- Modify: `lua/plugins/misc.lua` (Navigator and markview specs)
- Modify: `lua/plugins/mini.lua` (add event hint)

- [ ] **Step 1: Update Navigator.nvim to lazy-load on keymaps**

In `lua/plugins/misc.lua`, change Navigator spec:

Find:
```lua
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup {}
    end,
    lazy = false,
  },
```

Replace with:
```lua
  {
    'numToStr/Navigator.nvim',
    keys = {
      { '<C-h>', '<Cmd>NavigatorLeft<CR>', desc = 'Navigate left' },
      { '<C-l>', '<Cmd>NavigatorRight<CR>', desc = 'Navigate right' },
      { '<C-j>', '<Cmd>NavigatorDown<CR>', desc = 'Navigate down' },
      { '<C-k>', '<Cmd>NavigatorUp<CR>', desc = 'Navigate up' },
    },
    config = function()
      require('Navigator').setup {}
    end,
  },
```

- [ ] **Step 2: Restrict markview.nvim to markdown filetypes**

In `lua/plugins/misc.lua`, change markview spec:

Find:
```lua
  {
    'OXY2DEV/markview.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
```

Replace with:
```lua
  {
    'OXY2DEV/markview.nvim',
    ft = { 'markdown' },
```

- [ ] **Step 3: Add event hint to mini.nvim**

In `lua/plugins/mini.lua`, add `event`:

Find:
```lua
return {
 'nvim-mini/mini.nvim',
  version = '*',
```

Replace with:
```lua
return {
  'nvim-mini/mini.nvim',
  version = '*',
  event = 'VeryLazy',
```

- [ ] **Step 4: Verify Navigator loads only on keypress**

Start neovim, run:
```
:Lazy
```
Expected: Navigator.nvim shows as "Not Loaded".

Press `<C-h>`. Run `:Lazy` again. Expected: Navigator.nvim shows as "Loaded".

- [ ] **Step 5: Verify markdown still renders markview**

Open `README.md`. Expected: markview renders markdown formatting.

- [ ] **Step 6: Commit**

```bash
git add lua/plugins/misc.lua lua/plugins/mini.lua
git commit -m "perf(plugins): lazy-load Navigator on keys, restrict markview to markdown, add VeryLazy hint"
```

---

### Task 5: Add lazy.nvim performance settings

**Files:**
- Modify: `lua/configs/lazy.lua` (two line additions)

- [ ] **Step 1: Add performance.rtp.disabled_plugins**

In `lua/configs/lazy.lua`, find:
```lua
require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
}
```

Replace with:
```lua
require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'netrw',
        'netrwPlugin',
        'tar',
        'tarPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
}
```

- [ ] **Step 2: Verify startup still works**

```bash
nvim --startuptime /tmp/nvim-startup2.log +q
head -30 /tmp/nvim-startup2.log
```

Expected: No errors. Neovim opens normally.

- [ ] **Step 3: Commit**

```bash
git add lua/configs/lazy.lua
git commit -m "perf(lazy): disable unused built-in plugins at rtp level"
```

---

### Task 6: Validate and profile

- [ ] **Step 1: Profile startup time**

```bash
nvim --startuptime /tmp/nvim-startup-final.log +q
tail -5 /tmp/nvim-startup-final.log
```

Note the total startup time.

- [ ] **Step 2: Profile LSP completion latency**

Open a TypeScript file in a large project. Type a method call like `document.q` and measure time until LSP results appear (not buffer results). Use `:checkhealth lsp` to verify server health.

- [ ] **Step 3: Check all keymaps still work**

Run through the keymaps:
- `<C-h/j/k/l>` — tmux navigation
- `<leader>a` — which-key AI group
- `<leader>f` — format
- `<leader>/` — fzf-lua grep
- `<CR>` — accept completion
- `<C-k>/<C-j>` — navigate completion

Expected: All work as before.

- [ ] **Step 4: Final commit if any tweaks needed**

```bash
git add -A
git commit -m "chore: final validation tweaks"
```
