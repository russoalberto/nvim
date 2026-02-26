local opt = vim.opt

opt.breakindent = true        -- Enable break indent
opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.colorcolumn = '120'       -- Highlight column 120
opt.completeopt = 'menu,menuone,noselect'
opt.confirm = true            -- Confirm to save changes before exiting modified buffer
opt.cursorline = true         -- Enable highlighting of the current line
opt.expandtab = true          -- Use spaces instead of tabs
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.hlsearch = true
opt.ignorecase = true     -- Ignore case
opt.inccommand = 'split'  -- preview incremental substitute
opt.list = true           -- Show some invisible characters (tabs...
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.mouse = 'a'           -- Enable mouse mode
opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 12        -- Lines of context
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
opt.shiftwidth = 2        -- Size of an indent
opt.showmode = false      -- Dont show mode since we have a statusline
opt.sidescrolloff = 8     -- Columns of context
opt.signcolumn = 'yes'    -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true      -- Don't ignore case with capitals
opt.smartindent = true    -- Insert indents automatically
opt.spelllang = { 'en' }
opt.splitbelow = true     -- Put new windows below current
opt.splitright = true     -- Put new windows right of current
opt.swapfile = false      -- Disable swapfile
opt.tabstop = 2           -- Number of spaces tabs count for
opt.termguicolors = true  -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wrap = false     -- Disable line wrap

if vim.fn.has 'nvim-0.9.0' == 1 then
  opt.splitkeep = 'screen'
end
