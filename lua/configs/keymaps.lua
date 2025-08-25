-- Move to previous/next quickfix
vim.keymap.set('n', '<M-j>', ':cnext<CR>', { silent = true })
vim.keymap.set('n', '<M-k>', ':cprev<CR>', { silent = true })

-- Tmux
vim.keymap.set('n', '<C-h>', '<Cmd>NavigatorLeft<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', '<Cmd>NavigatorRight<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', '<Cmd>NavigatorDown<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', '<Cmd>NavigatorUp<CR>', { silent = true })

vim.keymap.set('n', '<leader>q', ':bdelete<CR>', { desc = '[Q]uit current buffer' })
vim.keymap.set('n', '<leader>Q', ':%bdelete<CR>', { desc = '[Q]uit all buffer' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic [E]rror' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, { desc = 'Open Diagnostic [E]rror list' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Save file
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'save file' })
vim.keymap.set({ 'n' }, '<leader>w', '<cmd>w<cr><esc>', { desc = 'Save file' })

--AI
vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = '[A]I [A]ctions' })
vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[A]I [C]hat' })
vim.keymap.set('v', '<leader>ad', '<cmd>CodeCompanionChat Add<cr>', { desc = '[A]I A[d]d' })

-- File explorer
vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { silent = true })

-- Zk notes
vim.keymap.set('n', '<leader>zn', '<Cmd>ZkNew<CR>', { desc = '[Z]k [N]ew' })
vim.keymap.set('n', '<leader>zl', '<Cmd>ZkNotes<CR>', { desc = '[Z]k [L]ist' })

-- Hardmode: disable arrow keys
vim.keymap.set({ 'v', 'n', 's' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Down>', '<Nop>', { silent = true })
