return {
  'stevearc/oil.nvim',
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<leader>v"] = { "actions.select", opts = { vertical = true }},
        ["<leader>h"] = { "actions.select", opts = { horizontal = true }},
      }
    })
  end
}
