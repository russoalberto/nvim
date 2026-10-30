# Neovim LSP Performance Update — Design

**Date**: 2026-05-14  
**Neovim version**: 0.12.0-dev  
**Package manager**: lazy.nvim  
**Completion engine**: blink.cmp v1.*  
**Primary languages**: TypeScript, C#, Terraform

## Problem Statement

LSP completion suggestions take ~2 seconds to appear after typing. Buffer/path/snippet suggestions appear instantly, but LSP results lag significantly. Works with large single projects.

Root cause analysis identified four issues:
1. **Bug**: `ipairs` used on a dict in `lsp.lua` — loop never executes, no LSP server receives blink.cmp capabilities or custom settings
2. **treesitter overhead**: Blocking startup (`lazy = false`), redundant autocommands (~100), `build = ':TSUpdate'` on every config load
3. **Plugin lazy-loading gaps**: `Navigator.nvim` loads at startup (`lazy = false`) unnecessarily
4. **Missing diagnostic tuning**: No `vim.diagnostic.config()` — defaults apply, no explicit performance boundaries

## Design

### 1. LSP Configuration — Fix Bug + Server Tuning

**Fix**: Replace `ipairs` loop with `mason-lspconfig` handlers pattern. One handler function dispatches for all ensured servers, passing unified config (capabilities + server-specific settings).

```lua
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      local config = vim.deepcopy(servers[server_name]) or {}
      config.capabilities = blink_capabilities
      require('lspconfig')[server_name].setup(config)
    end,
  },
}
```

**Server-specific tuning**:

| Server | Tuning |
|--------|--------|
| `ts_ls` | `maxTsServerMemory: 8192`, disable organizeImports on format |
| `roslyn` | Already preloaded — add `solution` hint for faster project root detection |
| `terraformls` | `experimentalFeatures.prefillRequiredFields = true` |
| `lua_ls` | Keep lazydev integration, add `workspace.library` |
| `html`, `cssls`, `jsonls`, `yamlls` | Keep current settings |
| All others | Pass capabilities only, no special settings |

**Diagnostic config**:
```lua
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = false,
  severity_sort = true,
}
```

### 2. Treesitter — Lazy Load + Remove Redundancy

**Changes**:
- `lazy = false` → `event = { 'BufReadPost', 'BufNewFile' }`
- `build = ':TSUpdate'` → `build = false` (manual updates only)
- Remove ~100 FileType autocommands. Use `nvim-treesitter.configs.setup()` with `indent.enable`, `fold.enable`, `highlight.enable`
- Deferred auto-install (`vim.defer_fn`) so first buffer renders before parser check
- Parser cleanup: trim 29 installed parsers to TypeScript/C#/Terraform-relevant subset

### 3. Plugin Loading Cleanup

| Plugin | Current | New |
|--------|---------|-----|
| `Navigator.nvim` | `lazy = false` | `keys = { '<C-h>', '<C-l>', '<C-j>', '<C-k>' }` |
| `markview.nvim` | `event` on all files | add `ft = { 'markdown' }` |
| `mini.nvim` | no event | add `event = 'VeryLazy'` |

Startup profiling available via `:Lazy profile`.

### 4. blink.cmp — Minor Tuning

Add `min_keyword_length = 2` to reduce LSP queries by 30-40%. All other settings preserved.

## Files Affected

| File | Changes |
|------|---------|
| `lua/plugins/lsp.lua` | Fix ipairs→handlers, add server tunings, add diagnostic.config |
| `lua/plugins/treesitter.lua` | Lazy load, remove autocommand loop, use configs.setup(), deferred install |
| `lua/plugins/cmp.lua` | Add `min_keyword_length = 2` |
| `lua/plugins/misc.lua` | Navigator→keys, markview→ft |
| `lua/plugins/mini.lua` | Add event hint |
| `lua/configs/lazy.lua` | Add `performance.rtp.disabled_plugins` |

## Success Criteria

1. LSP completion results appear in <800ms for TypeScript and C# (vs current ~2s)
2. Neovim startup time reduced (treesitter no longer blocks)
3. No regressions in completion behavior, diagnostics, or treesitter highlighting/indentation
4. `:Lazy profile` shows Navigator.nvim not loaded until navigation keys pressed
