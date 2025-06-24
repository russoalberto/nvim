return {
  -- AI
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "gemini",
          },
          inline = {
            adapter = "gemini",
            keymaps = {
              accept_change = {
                modes = { n = "gra" },
                description = "[A]ccept the suggested change",
              },
              reject_change = {
                modes = { n = "grj" },
                description = "Re[j]ect the suggested change",
              },
            },
          },
        },
        display = {
          action_palette = {
            provider = "snacks",
          },
        }
      })
    end,
  },
}
