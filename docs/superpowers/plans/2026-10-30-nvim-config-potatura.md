# Neovim Config Potatura A — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ridurre la configurazione Neovim al solo stack quotidiano (.NET, Angular/TypeScript, Prisma, SQL, Terraform/OpenTofu, Markdown, herdr) eliminando plugin inerti, server/parser/pacchetti inutilizzati e caricamenti non necessari all'avvio, senza cambiare l'UX.

**Architecture:** Si mantiene l'architettura attuale (lazy.nvim, blink.cmp, fzf-lua, oil, which-key, mini) e si applica una potatura conservativa. Le modifiche sono indipendenti per plugin spec; la pulizia distruttiva (`:Lazy clean`, `:MasonUninstall`) avviene solo dopo la verifica funzionale.

**Tech Stack:** Neovim 0.12.6, lazy.nvim, nvim-lspconfig + mason, blink.cmp, nvim-treesitter (branch main), conform.nvim, fzf-lua, oil.nvim, mini.nvim, OpenTofu 1.13.2.

**Spec:** `docs/superpowers/specs/2026-10-30-nvim-config-potatura-design.md`

## Global Constraints

- Neovim 0.12.6; non usare API rimosse o deprecated.
- Restare su lazy.nvim; non migrare a `vim.pack`.
- Leader = spazio, localleader = backslash; non cambiare le keymap esistenti.
- Mantenere Prisma, SQL e Terraform/OpenTofu (LSP, parser e formatter).
- Usare `tofu`/`tofu_fmt`, non `terraform`: il binario `terraform` non è installato.
- Non cambiare colorscheme, opzioni o keymap.
- Nessun commit senza richiesta esplicita dell'utente.
- Eseguire `:Lazy clean` e `:MasonUninstall` solo dopo aver verificato i task 1-5.
- Non eliminare plugin o pacchetti Mason oltre alle liste della spec.

## Review Focus

1. **Angular template**: un file `.html` Angular deve continuare ad avere `angularls`/`html` attivi e formattazione `prettier`.
2. **.NET**: un file `.cs` deve continuare ad avere `easy-dotnet`/roslyn e completion, anche dopo la rimozione dello stack DAP.
3. **OpenTofu**: un file `.tf` deve usare `tofu_ls` e `tofu_fmt`, mai `terraform`.
4. **Lazy-load**: il primo `-` e il primo `<leader>sf` devono funzionare dopo la rimozione del caricamento eager; `gra` deve continuare ad aprire i code action su fzf-lua.
5. **Parser rimossi**: Astro/C/PHP/Twig non devono più essere installati; il parser `css` deve essere presente e i file senza parser non devono generare errori.

---

### Task 1: Rimuovere i plugin inerti

**Files:**
- Delete: `lua/plugins/copilot.lua`
- Delete: `lua/plugins/dap.lua`
- Modify: `lua/plugins/lsp.lua:78-83`

**Interfaces:**
- Consumes: nessuna.
- Produces: set di plugin senza `copilot`, `nvim-dap`, `nvim-dap-ui`, `nvim-nio`.

- [ ] **Step 1: Eliminare i due file morti**

Eseguire dalla root del repo:

```bash
rm lua/plugins/copilot.lua lua/plugins/dap.lua
```

- [ ] **Step 2: Rimuovere `nvim-dap-ui` dalla libreria di lazydev**

In `lua/plugins/lsp.lua`, rimuovere la riga:

```lua
            'nvim-dap-ui',
```

Il blocco `library` deve restare:

```lua
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            'blink.cmp',
            'lazy.nvim',
          },
```

- [ ] **Step 3: Verificare che non restino riferimenti**

Run:

```bash
rg -n "copilot|nvim-dap|dap-ui|nvim-nio" lua/
```

Expected: nessun output.

- [ ] **Step 4: Verificare che Neovim parta senza errori**

Run:

```bash
nvim --headless +qa
```

Expected: exit code 0, nessun errore.

---

### Task 2: Potare i server LSP e aggiornare fidget

**Files:**
- Modify: `lua/plugins/lsp.lua:1-64`
- Modify: `lua/plugins/lsp.lua:73`

**Interfaces:**
- Consumes: tabella `servers` esistente.
- Produces: tabella `servers` con 15 server; `fidget.nvim` pinnato a `v2.0.0`.

- [ ] **Step 1: Rimuovere Astro, clangd e PHP**

In `lua/plugins/lsp.lua`, eliminare queste tre righe dalla tabella `servers`:

```lua
  astro = {},
  clangd = {},
  intelephense = {},
```

Non rimuovere `prismals`, `sqlls` o `tofu_ls`.

- [ ] **Step 2: Aggiornare fidget alla v2**

Sostituire:

```lua
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
```

con:

```lua
      { 'j-hui/fidget.nvim', tag = 'v2.0.0', opts = {} },
```

- [ ] **Step 3: Verificare le liste**

Run:

```bash
rg -n "^\s*(astro|clangd|intelephense)\s*=" lua/plugins/lsp.lua
rg -n "prismals|sqlls|tofu_ls|fidget" lua/plugins/lsp.lua
```

Expected: il primo comando non produce output; il secondo mostra `prismals`, `sqlls`, `tofu_ls` e `fidget` con `v2.0.0`.

- [ ] **Step 4: Verificare che lua_ls si avvii**

Run:

```bash
timeout 25s nvim --headless lua/plugins/lsp.lua \
  +'lua vim.wait(5000, function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end)' \
  +'lua print(vim.inspect(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))))' \
  +qa
```

Expected: stampa una lista che contiene `"lua_ls"`.

- [ ] **Step 5: Aggiornare fidget e verificare la tag**

Eseguire in Neovim:

```vim
:Lazy update fidget.nvim
```

Poi:

```bash
git -C ~/.local/share/nvim/lazy/fidget.nvim describe --tags
```

Expected: `v2.0.0`.

- [ ] **Step 6: Verifica funzionale LSP**

Aprire un progetto Angular con un file `.ts` e un template `.html`; eseguire `:lsp` (o `:LspInfo`) e verificare che siano attivi `angularls`, `ts_ls`, `html`, `cssls` e `tailwindcss`. Aprire un file `.cs` e verificare che `easy-dotnet`/roslyn sia attivo. Aprire un file `.tf` e verificare `tofu_ls`; un file `.sql` e verificare `sqlls`; un file `.prisma` e verificare `prismals`.

Expected: nessuno dei server rimossi (`astro`, `clangd`, `intelephense`) viene avviato.

---

### Task 3: Potare e semplificare treesitter

**Files:**
- Modify: `lua/plugins/treesitter.lua` (intero file)

**Interfaces:**
- Consumes: `ensure_installed` e `nvim-treesitter.config`.
- Produces: lista di 21 parser e una funzione locale `enable(bufnr, ft)` richiamata da un solo `FileType` autocmd.

- [ ] **Step 1: Sostituire il contenuto di `lua/plugins/treesitter.lua`**

```lua
local ensure_installed = {
  'angular',
  'bash',
  'c_sharp',
  'caddy',
  'css',
  'dockerfile',
  'hcl',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'prisma',
  'regex',
  'scss',
  'sql',
  'terraform',
  'tsx',
  'typescript',
  'yaml',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  event = { 'BufReadPre', 'BufNewFile' },
  build = false,
  config = function()
    local ts_config = require 'nvim-treesitter.config'
    ts_config.setup {}

    local already_installed = ts_config.get_installed 'parsers'
    local to_install = {}
    for _, parser in ipairs(ensure_installed) do
      if not vim.tbl_contains(already_installed, parser) then
        to_install[#to_install + 1] = parser
      end
    end
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    local function enable(bufnr, ft)
      local lang = vim.treesitter.language.get_lang(ft)
      if not lang then
        return
      end
      if not pcall(vim.treesitter.start, bufnr, lang) then
        return
      end
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = 'expr'
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        enable(args.buf, args.match)
      end,
    })

    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if ft ~= '' then
      enable(bufnr, ft)
    end
  end,
}
```

- [ ] **Step 2: Verificare che i parser rimossi non siano più in lista**

Run:

```bash
rg -n "'astro'|'c'|'php'|'twig'" lua/plugins/treesitter.lua
```

Expected: nessun output.

- [ ] **Step 3: Verificare il parser CSS e il folding su TypeScript**

Creare i file di prova:

```bash
printf 'const x: number = 1;\n' > /tmp/nvim-ts-test.ts
printf 'body { color: red; }\n' > /tmp/nvim-ts-test.css
```

Run:

```bash
nvim --headless /tmp/nvim-ts-test.ts \
  +'lua vim.wait(1000)' \
  +'lua print(vim.bo.filetype, vim.wo.foldmethod, vim.bo.indentexpr)' \
  +qa
```

Expected: `typescript expr v:lua.require'nvim-treesitter'.indentexpr()`.

Run:

```bash
nvim --headless /tmp/nvim-ts-test.css \
  +'lua vim.wait(3000)' \
  +'lua print(vim.treesitter.language.get_lang("css"))' \
  +qa
```

Expected: `css`. Se il parser non è ancora installato, eseguire `:TSInstall css` e ripetere.

- [ ] **Step 4: Verificare i file dello stack reale**

Per ciascun file, aprire in Neovim e controllare che l'highlighting e il folding funzionino senza errori:

```bash
printf '{"a":1}\n' > /tmp/nvim-ts-test.json
printf 'SELECT 1;\n' > /tmp/nvim-ts-test.sql
printf 'model User { id Int @id }\n' > /tmp/nvim-ts-test.prisma
printf '# Titolo\n\ntesto\n' > /tmp/nvim-ts-test.md
printf 'resource "null_resource" "x" {}\n' > /tmp/nvim-ts-test.tf
```

Expected: nessun errore `Error executing lua`; `:InspectTree` mostra un albero per almeno TypeScript, CSS, JSON, SQL, Prisma, Markdown e Terraform.

---

### Task 4: Passare il formatter Terraform a OpenTofu

**Files:**
- Modify: `lua/plugins/format.lua:12-22`

**Interfaces:**
- Consumes: `formatters_by_ft` di conform.
- Produces: mappa formatter senza PHP e con `terraform = { 'tofu_fmt' }`.

- [ ] **Step 1: Aggiornare `formatters_by_ft`**

Sostituire il blocco con:

```lua
  opts = {
    formatters_by_ft = {
      cs = { 'csharpier' },
      htmlangular = { 'prettier' },
      html = { 'prettier' },
      lua = { 'stylua' },
      terraform = { 'tofu_fmt' },
      typescript = { 'prettier' },
    },
  },
```

- [ ] **Step 2: Verificare che conform risolva `tofu_fmt`**

Run:

```bash
printf 'variable "x" {}\n' > /tmp/nvim-fmt-test.tf
nvim --headless -c "Lazy! load conform.nvim" /tmp/nvim-fmt-test.tf \
  +'lua print(vim.inspect(require("conform").list_formatters_for_buffer(0)))' \
  +qa
```

Expected: `{ "tofu_fmt" }`.

- [ ] **Step 3: Verificare la formattazione reale**

Run:

```bash
printf 'variable "x" {\ndefault = 1\n}\n' > /tmp/nvim-fmt-test.tf
nvim --headless -c "Lazy! load conform.nvim" /tmp/nvim-fmt-test.tf \
  +'lua require("conform").format({ async = false })' \
  +qa
sed -n '1,5p' /tmp/nvim-fmt-test.tf
```

Expected: il file è formattato da `tofu fmt`; nessun errore relativo a `terraform` mancante.

- [ ] **Step 4: Verificare che PHP sia sparito**

Run:

```bash
rg -n "php|terraform" lua/plugins/format.lua
```

Expected: nessuna riga con `php`; una riga con `terraform = { 'tofu_fmt' }`.

---

### Task 5: Lazy-load di fzf-lua e oil

**Files:**
- Modify: `lua/plugins/fzf.lua:58-60`
- Modify: `lua/plugins/oil.lua:1-3`

**Interfaces:**
- Consumes: spec esistenti di fzf-lua e oil.
- Produces: fzf-lua caricato dalle keymap; oil caricato dal comando `:Oil`.

- [ ] **Step 1: Rimuovere il caricamento eager di fzf-lua**

In `lua/plugins/fzf.lua`, eliminare il blocco finale:

```lua
  init = function()
    require('fzf-lua').register_ui_select()
  end,
```

Il file deve terminare con la chiusura di `opts` e `}`.

- [ ] **Step 2: Rendere oil lazy tramite comando**

In `lua/plugins/oil.lua`, aggiungere `cmd = 'Oil',` subito dopo la riga del repository:

```lua
return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  config = function()
```

- [ ] **Step 3: Verificare l'avvio**

Run:

```bash
nvim --startuptime /tmp/nvim-startup-after.log +qa
rg -n "fzf-lua|oil.nvim" /tmp/nvim-startup-after.log
```

Expected: nessun output (nessuno dei due plugin viene caricato all'avvio). Il baseline pre-modifica è in `/tmp/nvim-startup-before.log` e vale ~44.5 ms.

- [ ] **Step 4: Verifica funzionale manuale**

Aprire Neovim e premere `-`: deve aprirsi oil. Premere `<leader>sf`: deve aprirsi il picker file di fzf-lua. Premere `<leader>sg`: deve aprirsi il grep. Eseguire `:Lazy` e verificare che `fzf-lua` e `oil.nvim` risultino non caricati prima dell'uso.

Expected: nessun errore; i picker e oil funzionano al primo utilizzo.

---

### Task 6: Pulizia di plugin e pacchetti Mason

**Files:**
- Modify: `lazy-lock.json` (generato da lazy.nvim)
- Nessuna modifica manuale ai file Lua.

**Interfaces:**
- Consumes: spec aggiornate dei task 1-5.
- Produces: lockfile senza `nvim-dap`, `nvim-dap-ui`, `nvim-nio`; Mason senza i pacchetti elencati nella spec.

> **Fermarsi e chiedere conferma all'utente prima di questo task**: `:Lazy clean` elimina directory di plugin e `:MasonUninstall` rimuove pacchetti. Non eseguire senza conferma esplicita.

- [ ] **Step 1: Pulire i plugin non più referenziati**

Eseguire in Neovim:

```vim
:Lazy clean
```

Confermare la rimozione dei plugin elencati. Expected: `nvim-dap`, `nvim-dap-ui`, `nvim-nio` rimossi; nessun plugin ancora usato viene toccato.

- [ ] **Step 2: Verificare il lockfile**

Run:

```bash
rg -n "nvim-dap|dap-ui|nvim-nio" lazy-lock.json
```

Expected: nessun output.

- [ ] **Step 3: Disinstallare i pacchetti Mason non più usati**

Run:

```bash
nvim --headless \
  -c "Lazy! load mason.nvim" \
  -c "MasonUninstall astro-language-server clangd copilot-language-server codelldb delve gopls intelephense jinja-lsp netcoredbg ols php-cs-fixer rust-analyzer twiggy-language-server" \
  -c qall
```

Expected: i pacchetti vengono rimossi senza errori. I pacchetti condivisi o ancora richiesti (`roslyn`, `csharpier`, `prettier`, `stylua`, `tofu-ls`, `prismals`, `sqlls`, ecc.) restano.

- [ ] **Step 4: Verificare Mason**

Eseguire `:Mason` e controllare che i pacchetti rimasti siano quelli elencati nella spec. In alternativa:

```bash
nvim --headless -c "lua print(vim.inspect(vim.tbl_map(function(p) return p.name end, require('mason-registry').get_installed_packages())))" -c qall
```

Expected: nessuno dei pacchetti rimossi compare nella lista.

---

### Task 7: Verifica finale

**Files:**
- Nessuna modifica.

**Interfaces:**
- Consumes: tutti i task precedenti.
- Produces: report di verifica e diff pronto per la revisione.

- [ ] **Step 1: Misurare l'avvio**

Run:

```bash
nvim --startuptime /tmp/nvim-startup-final.log +qa
tail -3 /tmp/nvim-startup-final.log
```

Expected: nessun errore; tempo totale inferiore al baseline ~44.5 ms (atteso ~34-36 ms).

- [ ] **Step 2: Verificare che i plugin inerti non siano più caricati**

Run:

```bash
rg -n "nvim-dap|dap-ui|nvim-nio|copilot" /tmp/nvim-startup-final.log
```

Expected: nessun output.

- [ ] **Step 3: Verifica funzionale completa**

Aprire e testare:

- Angular: file `.ts`, template `.html`, `:lsp` con `angularls`, `ts_ls`, `html`, `cssls`, `tailwindcss`; `<leader>f` su TypeScript.
- .NET: file `.cs`, completion easy-dotnet/roslyn, `<leader>f` con csharpier.
- Terraform/OpenTofu: file `.tf`, `tofu_ls`, `<leader>f` con `tofu_fmt`.
- SQL: file `.sql`, `sqlls`.
- Prisma: file `.prisma`, `prismals`.
- Markdown: markview attivo, rendering inline.
- herdr: comandi herdr ancora disponibili.
- Keymap: `-` (oil), `<leader>sf`/`<leader>sg` (fzf), `gra` (code action), `<leader>f` (format), `<leader>e` (diagnostica), `<M-j>`/`<M-k>` (quickfix).

Expected: nessuna regressione.

- [ ] **Step 4: Controllare il diff**

Run:

```bash
git status --short
git diff --stat
git diff
```

Expected: solo i file previsti; nessun segreto, nessun file temporaneo, nessuna modifica a colorscheme/keymap/opzioni.

- [ ] **Step 5: Eseguire i checkhealth**

Run in Neovim:

```vim
:checkhealth lsp
:checkhealth mason
```

Expected: nessun errore bloccante; i server rimasti sono configurati e i pacchetti Mason attivi sono quelli attesi.

- [ ] **Step 6: Stop — nessun commit**

Non eseguire `git add`/`git commit` senza richiesta esplicita dell'utente. Riportare i risultati e attendere indicazioni.
