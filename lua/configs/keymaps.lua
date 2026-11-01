-- Reload buffer
vim.keymap.set('n', '<leader>r', ':e<CR>', { desc = '[R]eload buffer' })
-- Move to previous/next quickfix
vim.keymap.set('n', '<M-j>', ':cnext<CR>', { silent = true })
vim.keymap.set('n', '<M-k>', ':cprev<CR>', { silent = true })

vim.keymap.set('n', '<leader>q', ':bdelete<CR>', { desc = '[Q]uit current buffer' })
vim.keymap.set('n', '<leader>Q', ':%bdelete<CR>', { desc = '[Q]uit all buffer' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic [E]rror' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Save file
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'save file' })
vim.keymap.set({ 'n' }, '<leader>w', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- File explorer
vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { silent = true })

-- Hardmode: disable arrow keys
vim.keymap.set({ 'v', 'n', 's' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Down>', '<Nop>', { silent = true })
