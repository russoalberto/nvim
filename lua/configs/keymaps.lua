local wk = require 'which-key'

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', opts)

-- BufferLine
wk.register({
  b = {
    name = 'BufferLine',
    k = { '<Cmd>BufferLinePick<CR>', 'Pick buffer' },
    K = { '<Cmd>BufferLinePickClose<CR>', 'Close buffer' },
    p = { '<Cmd>BufferLineTogglePin<CR>', 'Pin buffer' },
    P = { '<Cmd>BufferLineGroupClose ungrouped<CR>', 'Unpin buffer' },
    b = { '<Cmd>Bdelete<CR>', 'Close buffer' },
    t = { '<Cmd>BufferLineSortByTabs<CR>', 'Sort by tabs' },
    s = { '<Cmd>BufferLineSortByDirectory<CR>', 'Sort by directory' },
    r = { '<Cmd>BufferLineSortByRelativeDirectory<CR>', 'Sort by relative directory' },
    e = { '<Cmd>:set modifiable!<CR>', 'Toggle modificable status to buffer' },
  },
}, {
  prefix = '<leader>',
})

-- neoTree
map('n', '<A-t>', '<Cmd>Neotree toggle<CR>', opts)

-- LSP format
vim.keymap.set('n', '<A-i>', function()
  vim.lsp.buf.format { async = true }
end, { silent = true })

-- Zen mode
wk.register({
  z = {
    name = 'Zen mode',
    z = { '<Cmd>ZenMode<CR>', 'Toggle zen mode' },
  },
}, {
  prefix = '<leader>',
})

-- Undo tree
wk.register({
  h = {
    name = 'Undo tree',
    s = { '<Cmd>UndotreeShow<CR>', 'Show undo tree' },
    h = { '<Cmd>UndotreeHide<CR>', 'Hide undo tree' },
    t = { '<Cmd>UndotreeToggle<CR>', 'Toggle undo tree' },
  },
}, {
  prefix = '<leader>',
})

map('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', opts)
map('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', opts)
map('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', opts)
map('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', opts)

-- LazyGit
map('n', '<leader>gg', '<Cmd>LazyGit<CR>', opts)

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch existing [B]uffers' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- better up/down
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
  { desc = 'Redraw / clear hlsearch / diff update' })

vim.keymap.set({ 'n', 'x' }, 'gw', '*N', { desc = 'Search word under cursor' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'nn'[v:searchforward]", { expr = true, desc = 'next search result' })
vim.keymap.set('x', 'n', "'nn'[v:searchforward]", { expr = true, desc = 'next search result' })
vim.keymap.set('o', 'n', "'nn'[v:searchforward]", { expr = true, desc = 'next search result' })
vim.keymap.set('n', 'n', "'nn'[v:searchforward]", { expr = true, desc = 'prev search result' })
vim.keymap.set('x', 'n', "'nn'[v:searchforward]", { expr = true, desc = 'prev search result' })
vim.keymap.set('o', 'n', "'nn'[v:searchforward]", { expr = true, desc = 'prev search result' })

-- add undo break-points
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

-- save file
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'save file' })

--keywordprg
vim.keymap.set('n', '<leader>k', '<cmd>norm! k<cr>', { desc = 'keywordprg' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- highlights under cursor
if vim.fn.has 'nvim-0.9.0' == 1 then
  vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
end

-- Hardmode: disable arrow keys
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<Down>', '<Nop>', { silent = true })
