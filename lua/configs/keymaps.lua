-- Move to previous/next
vim.keymap.set("n", "<A-,>", ":bprev<enter>", { silent = true })
vim.keymap.set("n", "<A-.>", ":bnext<enter>", { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic [E]rror' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, { desc = 'Open Diagnostic [E]rror list' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Save file
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'save file' })
vim.keymap.set({ 'n' }, '<leader>w', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = '[L]azy' })

-- Mason
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = '[M]ason' })

-- Format
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Buffer [F]ormat' })


--AI
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>",
  { desc = '[A]I [A]ctions', noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",
  { desc = '[A]I [C]hat', noremap = true, silent = true })
vim.keymap.set("v", "<leader>ad", "<cmd>CodeCompanionChat Add<cr>",
  { desc = '[A]I A[d]d', noremap = true, silent = true })

-- Hardmode: disable arrow keys
vim.keymap.set({ 'v', 'n', 's' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Down>', '<Nop>', { silent = true })
