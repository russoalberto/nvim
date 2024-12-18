return {
  -- AI
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "gemini",
      hints = { enabled = true },
    },
    build = ":AvanteBuild",
    dependencies = {
      "stevearc/dressing.nvim",
      "MunifTanjim/nui.nvim",

    }
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },
}
