return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ["<Tab>"] = { "select_next", "select_and_accept", "fallback" },
        ["<S-Tab>"] = { "select_prev", "select_and_accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        cmdline = {},
      },
      signature = { enabled = true }
    },
    opts_extend = { "sources.default" }
  }
}
