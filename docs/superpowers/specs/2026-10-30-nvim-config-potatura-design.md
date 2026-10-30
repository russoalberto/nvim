# Neovim config — Potatura A — Design

**Data**: 2026-10-30
**Stato**: proposta, in attesa di approvazione
**Neovim**: 0.12.6
**Package manager**: lazy.nvim
**Stack quotidiano**: C#/.NET, Angular/TypeScript, Prisma, SQL, Terraform/OpenTofu, Markdown, herdr

## Intent

Aggiornare la configurazione senza cambiarne l'UX: togliere plugin e codice morti, ridurre server LSP, parser e pacchetti Mason alle lingue realmente usate, e rimuovere i caricamenti non necessari all'avvio. L'obiettivo è una configurazione più semplice da mantenere, non un cambio di strumenti.

## Goals

- Eliminare plugin e file inerti o commentati.
- Potare LSP, treesitter e Mason sullo stack reale, mantenendo Prisma, SQL e Terraform/OpenTofu.
- Caricare `fzf-lua` e `oil` solo quando servono.
- Semplificare il wiring di treesitter.
- Aggiornare `fidget` dalla tag `legacy` (2023) alla v2.
- Usare `tofu fmt` per Terraform, dato che `terraform` non è installato.
- Non perdere keymap, formattazione, completion, markdown preview o herdr.

## Non-goals

- Non passare a `mini.pick`, `mini.files`, `mini.clue` o `snacks.nvim`.
- Non passare a `vim.pack`.
- Non aggiungere ESLint, DAP o altre funzionalità non richieste.
- Non cambiare colorscheme, leader key o keymap esistenti.

## Approccio scelto

**A — Potatura conservativa.** Si tiene l'architettura attuale (lazy.nvim, blink.cmp, fzf-lua, oil, which-key, mini) e si rimuove il peso morto. Le alternative sono state scartate:

- **B — Mini-first**: un solo ecosistema, ma perde i picker git/LSP più ricchi di fzf-lua e l'editing-buffer di oil. Rimandata.
- **C — Snacks-first**: aggiunge un secondo ecosistema, repo meno attivo e explorer non equivalente a oil. Scartata.

## Cosa resta

Plugin che restano, con il motivo:

- `lazy.nvim`: lazy-loading per event/keys e lockfile maturo. `vim.pack` è ancora experimental e non offre gli stessi trigger.
- `blink.cmp`: completion LSP con sorgente easy-dotnet, snippet, path, buffer e signature. La completion nativa 0.12 è più povera per questo stack.
- `fzf-lua`: picker principale per file, grep, buffer, LSP, git e diagnostica.
- `oil.nvim`: file manager con editing del buffer.
- `which-key.nvim`: scoperta delle keymap.
- `nvim-lspconfig` + `mason` + `mason-lspconfig`: config dei server e installazione dei binari. `:lsp` nativo sostituisce `:LspInfo`, non le config.
- `nvim-treesitter`: installazione parser e query. `vim.treesitter.start()` e `foldexpr()` sono nativi, ma non installano i parser.
- `conform.nvim`: formatter esterni (prettier, csharpier, stylua, tofu).
- `markview.nvim`: rendering inline del markdown. L'highlight treesitter nativo non lo sostituisce.
- `fidget.nvim` v2: progresso LSP flottante, utile con Angular/roslyn.
- `plenary.nvim`: usato da easy-dotnet (Job/picker).
- `mini.nvim`: ai, bracketed, diff, git, icons, move, statusline, surround.
- `herdr-nvim`, `gruvbox.nvim`, `friendly-snippets`, `lazydev.nvim`, `easy-dotnet.nvim`.

## Cosa viene rimosso

### Plugin

- `lua/plugins/copilot.lua`: contenuto interamente commentato, tabella vuota. Eliminato.
- `lua/plugins/dap.lua`: `nvim-dap`, `nvim-dap-ui`, `nvim-nio` non hanno setup, keymap o UI inizializzata. Eliminato.
  - Conseguenza: il debug .NET di easy-dotnet non sarà disponibile. Se serve, si riaggiunge in un secondo momento con una configurazione reale.

### LSP (da 18 a 15 server)

Restano:

`angularls`, `bashls`, `cssls`, `docker_compose_language_service`, `dockerls`, `html`, `jsonls`, `lua_ls`, `marksman`, `prismals`, `sqlls`, `tailwindcss`, `tofu_ls`, `ts_ls`, `yamlls`.

Escono:

`astro`, `clangd`, `intelephense`.

### Treesitter (da 24 a 21 parser)

Restano:

`angular`, `bash`, `c_sharp`, `caddy`, `css`, `dockerfile`, `hcl`, `html`, `javascript`, `json`, `lua`, `markdown`, `markdown_inline`, `prisma`, `regex`, `scss`, `sql`, `terraform`, `tsx`, `typescript`, `yaml`.

Escono:

`astro`, `c`, `php`, `twig`.

Nota: `css` viene aggiunto esplicitamente; mancava dalla lista pur essendo usato da Angular/CSS.

### Mason

Restano:

`angular-language-server`, `bash-language-server`, `csharpier`, `css-lsp`, `docker-compose-language-service`, `dockerfile-language-server`, `html-lsp`, `json-lsp`, `lua-language-server`, `marksman`, `prettier`, `prisma-language-server`, `roslyn`, `sqlls`, `stylua`, `tailwindcss-language-server`, `tofu-ls`, `typescript-language-server`, `yaml-language-server`.

Escono:

`astro-language-server`, `clangd`, `copilot-language-server`, `codelldb`, `delve`, `gopls`, `intelephense`, `jinja-lsp`, `netcoredbg`, `ols`, `php-cs-fixer`, `rust-analyzer`, `twiggy-language-server`.

La disinstallazione va fatta da `:Mason` dopo l'approvazione, non automaticamente.

### Formatter

- Rimosso `php = { 'php_cs_fixer' }`.
- `terraform` passa da `terraform` a `tofu_fmt` (OpenTofu 1.13.2 è installato; `terraform` non c'è).

## Cosa rende nativo Neovim 0.12

Verificato su 0.12.6:

| Funzione 0.12 | Sostituisce | Decisione |
|---|---|---|
| `vim.pack` (plugin manager, lockfile, update UI, experimental) | lazy.nvim | Non conviene ora: mancano i trigger event/keys e la UI è meno matura. |
| `vim.lsp.completion` (autotrigger, preview, inline completion, `cmp`) | blink.cmp | Non basta per easy-dotnet, snippet, path, buffer e signature. Resta blink. |
| `vim.lsp.status()` + `vim.ui.progress_status()` | fidget.nvim | fidget resta, aggiornato a v2; la statusline nativa è un'alternativa se lo si vuole togliere. |
| `vim.treesitter.start()` + `foldexpr()` | parte del wiring treesitter | Il folding custom si semplifica; i parser restano a nvim-treesitter. |
| `vim.ui.select()` | `fzf-lua.register_ui_select()` | Si toglie il register eager; i picker fzf restano. |
| `:lsp` | `:LspInfo` di lspconfig | Sostituisce il comando informativo, non le config dei server. |
| `vim.hl.on_yank()` | plugin highlight-yank | Già usato. |
| `vim.diagnostic.jump()` / `status()` | plugin diagnostica | Non usati. |
| `vim.lsp.inlay_hint` | plugin inlay hint | Non usati. |
| `vim.snippet` | LuaSnip | Non usato. |
| `:Undotree`, `:DiffTool` | undotree/diffview | Non installati. |
| Highlight treesitter markdown di default | markview | No: markview renderizza inline, non solo highlight. |

## Modifiche per file

| File | Modifica |
|---|---|
| `lua/plugins/copilot.lua` | Eliminato. |
| `lua/plugins/dap.lua` | Eliminato. |
| `lua/plugins/fzf.lua` | Rimosso il blocco `init` con `register_ui_select`. Le keymap restano e fanno lazy-load. |
| `lua/plugins/oil.lua` | Aggiunto `cmd = 'Oil'` per il lazy-load; la keymap `-` continua a funzionare. |
| `lua/plugins/lsp.lua` | Tolti `astro`, `clangd`, `intelephense`; `fidget` passa a v2.0.0; rimosso `nvim-dap-ui` dalla libreria di `lazydev`. |
| `lua/plugins/treesitter.lua` | Lista parser aggiornata; un solo `FileType` autocmd al posto del loop per parser; installazione dei parser mancanti invariata. |
| `lua/plugins/format.lua` | Rimosso PHP; `terraform` → `tofu_fmt`. |
| `lazy-lock.json` | Aggiornato da lazy.nvim dopo la rimozione dei plugin. |
| `lua/configs/*` | Nessuna modifica. |

## Verifica

1. `nvim --startuptime /tmp/nvim-startup.log +qa` prima e dopo; atteso ~34-36 ms (da ~43 ms).
2. `:Lazy` deve mostrare `fzf-lua` e `oil` come non caricati all'avvio.
3. `:Lazy clean` per rimuovere i plugin non più referenziati (con conferma).
4. `:Mason` per disinstallare i pacchetti elencati.
5. Aprire e verificare:
   - un file `.ts`/`.html` Angular: `angularls`, `ts_ls`, `html`, `cssls`, `tailwindcss`, completion e `<leader>f`;
   - un file `.cs`: `easy-dotnet`/roslyn, completion e `csharpier`;
   - un file `.tf`: `tofu_ls` e `tofu_fmt`;
   - un file `.sql`, `.prisma`, `.md`.
6. `:checkhealth lsp`, `:checkhealth mason`.
7. Test manuale di `-` (oil), `<leader>sf`, `<leader>sg`, `gra`, `<leader>f`, markdown preview e herdr.
8. `git diff` completo prima di qualsiasi commit.

## Rischi e assunzioni

- **DAP**: rimosso. Se debugghi .NET da Neovim, va riaggiunto `nvim-dap` + `nvim-dap-ui` + `nvim-nio` + `netcoredbg` con keymap reali.
- **`vim.ui.select`**: senza `register_ui_select`, i plugin che usano `vim.ui.select` useranno la UI nativa. I code action via `gra` restano su fzf-lua.
- **`fidget` v2**: cambio di major rispetto alla tag `legacy`; con `opts = {}` dovrebbe essere trasparente, ma va verificato.
- **Lingue rimosse**: Astro, C/C++, PHP e Twig perdono LSP/parser fino a una futura riaggiunta.
- **`tofu_fmt`**: richiede `tofu` nel PATH (presente, v1.13.2).
- **`oil` lazy**: il primo `-` può avere un piccolo ritardo di caricamento.
- **Nessun commit** verrà creato senza richiesta esplicita.

## Criteri di successo

- Startup più veloce e nessun plugin inerte caricato.
- Nessuna regressione su Angular/TypeScript, .NET, Prisma, SQL, Terraform/OpenTofu, Markdown e herdr.
- Config più corta e con meno server/parser/pacchetti da mantenere.
- `:Lazy` e `:Mason` senza voci inutilizzate.
