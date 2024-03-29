local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move to previous/next
vim.keymap.set("n", "<A->>", ":blast<enter>", opts)
vim.keymap.set("n", "<A-<>", ":bfirst<enter>", opts)
vim.keymap.set("n", "<A-,>", ":bprev<enter>", opts)
vim.keymap.set("n", "<A-.>", ":bnext<enter>", opts)
vim.keymap.set("n", "<leader>q", ":bdelete<enter>", { desc = '[Q]uit current buffer' })

-- File Explorer
vim.keymap.set('n', '<A-f>', '<Cmd>Ex<CR>', opts)

-- Undo tree
vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<cr>', { desc = '[U]ndo tree' })

-- Tmux
vim.keymap.set('n', '<C-h>', '<Cmd>NavigatorLeft<CR>', opts)
vim.keymap.set('n', '<C-l>', '<Cmd>NavigatorRight<CR>', opts)
vim.keymap.set('n', '<C-j>', '<Cmd>NavigatorDown<CR>', opts)
vim.keymap.set('n', '<C-k>', '<Cmd>NavigatorUp<CR>', opts)

-- LazyGit
vim.keymap.set('n', '<leader>gg', '<Cmd>LazyGit<CR>', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic [E]rror' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Oper [D]iagnostics list' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Search
vim.keymap.set({ 'n', 'x' }, 'gw', '*N', { desc = 'Search word under cursor' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Save file
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'save file' })

-- Lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = '[L]azy' })

-- Mason
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = '[M]ason' })

-- Hardmode: disable arrow keys
vim.keymap.set({ 'v', 'n', 's' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Down>', '<Nop>', { silent = true })
