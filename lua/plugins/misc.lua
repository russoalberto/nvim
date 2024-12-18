return {
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.diff').setup()
      require('mini.git').setup()
      require('mini.icons').setup()
      require('mini.statusline').setup()
      require('mini.surround').setup()
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = {
        enabled = true,
        notify = false,           -- show notification when big file detected
        size = 1.5 * 1024 * 1024, -- 1.5MB
      },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
          { section = "startup" },
        },
      },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false,            -- show open fold icons
          git_hl = false,          -- use Git Signs hl for fold icons
        },
        git = {
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = true },
      zen = { enabled = true },
      term = { enabled = true },
    },
    keys = {
      { "<leader>z",  function() Snacks.zen() end,              desc = "Toggle Zen Mode" },
      { "<leader>Z",  function() Snacks.zen.zoom() end,         desc = "Toggle Zoom" },
      { "<leader>q",  function() Snacks.bufdelete() end,        desc = "[Q]uit Buffer" },
      { "<leader>Q",  function() Snacks.bufdelete.all() end,    desc = "[Q]uit All Buffers" },
      { "<leader>gB", function() Snacks.gitbrowse() end,        desc = "Git Browse",                  mode = { "n", "v" } },
      { "<leader>gb", function() Snacks.git.blame_line() end,   desc = "Git Blame Line" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end,          desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end,      desc = "Lazygit Log (cwd)" },
      { "<c-/>",      function() Snacks.terminal() end,         desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end,         desc = "which_key_ignore" },
    },
  },
  { "alexghergh/nvim-tmux-navigation" }
}
