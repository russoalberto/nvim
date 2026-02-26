return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "ThePrimeagen/harpoon",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("harpoon")
      end,
    }, 
    -- change some options
    opts = {
      defaults = {
        path_display = {
          shorten = {
            len = 3,
            exclude = { 1, -1 },
          },
          truncate = true,
        },
      },
    },
  },
}
