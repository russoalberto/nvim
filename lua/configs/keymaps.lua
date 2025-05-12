-- Move to previous/next
vim.keymap.set("n", "<A-,>", ":bprev<enter>", { silent = true })
vim.keymap.set("n", "<A-.>", ":bnext<enter>", { silent = true })
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = '[Q]uit current buffer' })
vim.keymap.set("n", "<leader>Q", ":%bdelete<CR>", { desc = '[Q]uit all buffer' })

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
vim.keymap.set({ 'i', 'v', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'save file' })

-- Lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = '[L]azy' })

-- Mason
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = '[M]ason' })

-- Format
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat buffer' })

--AI
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>",
  { desc = '[A]I [A]ctions', noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat<cr>",
  { desc = '[A]I [C]hat', noremap = true, silent = true })
vim.keymap.set("v", "<leader>ad", "<cmd>CodeCompanionChat Add<cr>",
  { desc = '[A]I A[d]d', noremap = true, silent = true })

-- Telekasten
vim.keymap.set("n", "<leader>tp", "<cmd>Telekasten panel<CR>", { desc = '[T]elekasten panel' })
vim.keymap.set("n", "<leader>tf", "<cmd>Telekasten find_notes<CR>", { desc = '[T]elekasten find_notes' })
vim.keymap.set("n", "<leader>tg", "<cmd>Telekasten search_notes<CR>", { desc = '[T]elekasten search_notes' })
vim.keymap.set("n", "<leader>td", "<cmd>Telekasten goto_today<CR>", { desc = '[T]elekasten goto_today' })
vim.keymap.set("n", "<leader>tz", "<cmd>Telekasten follow_link<CR>", { desc = '[T]elekasten follow_link' })
vim.keymap.set("n", "<leader>tn", "<cmd>Telekasten new_note<CR>", { desc = '[T]elekasten new_note' })
vim.keymap.set("n", "<leader>tc", "<cmd>Telekasten show_calendar<CR>", { desc = '[T]elekasten show_calendar' })
vim.keymap.set("n", "<leader>tb", "<cmd>Telekasten show_backlinks<CR>", { desc = '[T]elekasten show_backlinks' })
vim.keymap.set("n", "<leader>tI", "<cmd>Telekasten insert_img_link<CR>", { desc = '[T]elekasten insert_img_link' })
-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>", { desc = '[T]elekasten insert_link' })

-- Hardmode: disable arrow keys
vim.keymap.set({ 'v', 'n', 's' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'v', 'n', 's' }, '<Down>', '<Nop>', { silent = true })
