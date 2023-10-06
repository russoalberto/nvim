local wk = require 'which-key'

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferLineMovePrev<CR>', opts)
map('n', '<A->>', '<Cmd>BufferLineMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', opts)

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
  },
}, {
  prefix = '<leader>',
})

-- neoTree
map('n', '<A-t>', '<Cmd>Neotree<CR>', opts)

-- LSP format
vim.keymap.set('n', '<A-i>', function()
  vim.lsp.buf.format { async = true }
end, { silent = true })

vim.keymap.set('n', '<leader>xf', function()
  vim.lsp.buf.code_action {
    apply = true,
  }
end, { noremap = true, silent = true, desc = 'Code fix code_actions' })

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

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
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

vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
  { desc = 'Redraw / clear hlsearch / diff update' })

vim.keymap.set({ 'n', 'x' }, 'gw', '*N', { desc = 'Search word under cursor' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Add undo break-points
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

-- save file
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

--keywordprg
vim.keymap.set('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- new file
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

vim.keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
vim.keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

-- toggle options
if vim.lsp.inlay_hint then
  vim.keymap.set('n', '<leader>uh', function()
    vim.lsp.inlay_hint(0, nil)
  end, { desc = 'Toggle Inlay Hints' })
end

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- highlights under cursor
if vim.fn.has 'nvim-0.9.0' == 1 then
  vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
end

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- windows
vim.keymap.set('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
vim.keymap.set('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
vim.keymap.set('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

-- tabs
vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Zk note
wk.register({
  z = {
    name = 'Zk',
    n = { "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", 'Create a new note' },
    o = { "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", 'Open notes' },
    t = { '<Cmd>ZkTags<CR>', 'Open notes usign seected tags' },
    f = { "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", 'Search notes' },
  },
}, {
  prefix = '<leader>',
})
-- Search for the notes matching the current visual selection.
vim.api.nvim_set_keymap('v', '<leader>zf', ":'<,'>ZkMatch<CR>", opts)
