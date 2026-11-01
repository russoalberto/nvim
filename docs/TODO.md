# TODO / note configurazione Neovim

Aggiornato: 2026-11-01

## Rinviato

- **Monitoraggio `lsp.log`**: `~/.local/state/nvim/lsp.log` può crescere molto
  (era arrivato a 471 MB per il rumore di `tofu-ls`). Dopo il fix `root_dir`
  dovrebbe restare più piccolo. Controllare periodicamente; valutare di alzare
  il livello di log a `error` o di troncare il file.
- **`vim.ui.select`**: dopo la rimozione del caricamento eager di `fzf-lua`,
  `vim.ui.select` usa il fallback nativo. Se compaiono inconsistenze nell'UI,
  aggiungere un wrapper lazy che carichi `fzf-lua` solo quando serve.
- **`scripts/check.sh`**: smoke test opzionale con
  `nvim --headless "+Lazy! load all" +qa` e una soglia di startup.
- **`sqls`**: il LSP è installato e si aggancia ai file `.sql`, ma serve un
  `config.yml` con la connessione PostgreSQL per avere completions e diagnostica
  reali. Senza config stampa `LSP[sqls] no database connection`.

## Non modificare (decisioni prese)

- Non sostituire `fzf-lua`, `oil.nvim` o `which-key` con `mini.pick` /
  `mini.files` / `mini.clue` o con `snacks.nvim`: l'UX attuale è voluta.
- Non aggiungere plugin AI dedicati: `herdr-nvim` è sufficiente.
- Non potare altri server LSP o parser Treesitter: lo stack attuale è giustificato
  da .NET, Angular/TypeScript, Prisma, SQL, Terraform/OpenTofu e Markdown.

## Herdr

- `herdr integration install claude` (la versione installata è v10, la corrente è v11).
- `herdr integration install opencode` (non installato).
- `pi` è già aggiornato.

## Note ambientali (non configurazione)

- `prismals` esce con errore se aperto direttamente in `/tmp`: scansiona `/tmp`
  e incontra `EACCES` sulle directory private di systemd. In un progetto normale
  funziona.
- `tofu-ls` può loggare errori di credenziali S3 quando apre file Terraform con
  backend S3: dipende dall'ambiente/credenziali, non dalla configurazione.
