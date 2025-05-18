return {
  {
    'saghen/blink.cmp',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { "rafamadriz/friendly-snippets" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      fuzzy = { implementation = "lua" },
      cmdline = {
        enabled = false,
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      keymap = {
        preset = 'enter',
        ["<Tab>"] = { "select_next", "select_and_accept", "fallback" },
        ["<S-Tab>"] = { "select_prev", "select_and_accept", "fallback" },
      },
    },
    opts_extend = { "sources.default" }
  }
}
