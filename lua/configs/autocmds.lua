local function augroup(name)
  return vim.api.nvim_create_augroup('nvim_' .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  command = 'checktime',
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup 'resize_splits',
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local exclude = { 'gitcommit' }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
    'oil',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})


vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup 'lsp_attach',
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local setOpts = function(desc)
      return { buffer = ev.buf, desc = desc }
    end
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, setOpts('[G]oto [D]eclaration'))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, setOpts('[G]oto [D]efinition'))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, setOpts('[G]oto [R]eferences'))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, setOpts('[G]oto [I]mplementation'))
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, setOpts('[W]orkspace [A]dd Folder'))
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, setOpts('[W]orkspace [R]emove Folder'))
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, setOpts('[W]orkspace [L]ist Folders'))
    vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, setOpts('[R]e[n]ame'))
    vim.keymap.set({ 'n', 'v' }, '<leader>ra', vim.lsp.buf.code_action, setOpts('[C]ode [A]ction'))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, setOpts('Hover Documentation'))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, setOpts('Signature Documentation'))
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, setOpts('Type [D]efinition'))
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, setOpts('Format'))
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(ev.buf, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format { async = false }
      end
    })
  end
})
