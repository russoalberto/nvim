return {
  {
    'saghen/blink.cmp',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp"
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },
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
