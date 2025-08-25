return {
  'ibhagwan/fzf-lua',
  keys = {
    { '<leader><space>', '<cmd>FzfLua files<cr>', desc = '[S]earch file under cur dir' },
    { '<leader>sf', '<cmd>FzfLua files<cr>', desc = '[S]earch [f]ile under cur dir' },
    { '<leader>sg', '<cmd>FzfLua grep<cr><cr>', desc = '[S]earch files with [g]rep' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = '[S]earch [w]ord under cursor' },
    { '<leader>sw', '<cmd>FzfLua grep_visual<cr>', desc = '[S]earch [w]ord under cursor', mode = 'v' },
    { '<leader>sG', '<cmd>FzfLua git_files<cr>', desc = '[S]earch file under [G]it repo' },
    { '<leader>b', '<cmd>FzfLua buffers<cr>', desc = '[S]earch [B]ufferss' },
    { '<leader>sb', '<cmd>FzfLua buffers<cr>', desc = '[S]earch [B]ufferss' },
    { '<leader>so', '<cmd>FzfLua oldfiles<cr>', desc = '[S]earch [O]ldfiles' },
    { '<leader>.', '<cmd>FzfLua oldfiles<cr>', desc = '[S]earch [O]ldfiles' },
    { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = '[R]esume last [f]ind result' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = '[S]earch buffer [d]iagnostic' },
    { '<leader>gb', '<cmd>FzfLua git_bcommits<cr>', desc = '[G]it [B]uffer commits' },
    { '<leader>gl', '<cmd>FzfLua git_blame<cr>', desc = '[G]it blame [L]ine' },
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = '[G]it [C]ommits (cwd)' },
    { 'grd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Goto [D]efinition' },
    { 'grD', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Goto [D]eclaration' },
    { 'grr', '<cmd>FzfLua lsp_references<cr>', desc = '[R]eferences' },
    { 'gri', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Goto [I]mplementation' },
    { 'grt', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Goto [T]ype Definition' },
    { 'gra', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'LSP Code [A]ctions' },
    { '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'LSP [S]ymbols' },
    { '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'LSP Workspace [S]ymbols' },
    { '<leader>sh', '<cmd>FzfLua helptags<cr>', desc = '[S]earch [H]elp' },
    { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = '[S]earch [M]arks' },
    { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = '[S]earch [Q]uickfix' },
  },
  opts = {
    oldfiles = {
      include_current_session = true,
      cwd_only = true,
    },
    files = {
      hidden = true,
    },
    keymap = {
      fzf = {
        ['tab'] = 'down',
        ['btab'] = 'up',
        ['ctrl-q'] = 'select-all+accept',
        ['alt-t'] = 'toggle',
      },
    },
    fzf_opts = { ['--cycle'] = true },
  },
  init = function()
    require('fzf-lua').register_ui_select()
  end,
}
