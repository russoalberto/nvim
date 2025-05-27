-- Move to previous/next
vim.keymap.set("n", "<A-,>", ":bprev<enter>", { silent = true })
vim.keymap.set("n", "<A-.>", ":bnext<enter>", { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic [E]rror' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, { desc = 'Open Diagnostic [E]rror list' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

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

-- Lsp
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[C]ode [R]ename' })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction'})
vim.keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, {desc = '[C]ode [D]ocumentation'})
vim.keymap.set('n', '<leader>cd', vim.lsp.buf.type_definition, {desc = '[C]ode [D]efinition'})

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
