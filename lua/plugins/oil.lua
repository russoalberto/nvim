return {
  'stevearc/oil.nvim',
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<A-s>"] = "actions.select_vsplit",
        ["<A-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = false,
    })
    -- File Explorer
    vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { silent = true })
    vim.keymap.set('n', '<leader>-', '<Cmd>Oil --float<CR>', { desc = '[-] File Explorer' })
  end
}
