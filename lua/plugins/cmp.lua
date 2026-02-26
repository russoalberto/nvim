return {
  'saghen/blink.cmp',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    signature = { enabled = true },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
    },
  },
}
