return {
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      provider = "gemini",
      providers = {
        gemini = {
          model = "gemini-2.5-flash-preview-05-20",
        },
      },
      selector = {
        --- @type avante.SelectorProvider
        provider = "snacks",
        -- Options override for custom providers
        provider_opts = {},
      }
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  }
}
