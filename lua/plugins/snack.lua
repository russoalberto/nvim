return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {
        notify = false,
        size = 1.5 * 1024 * 1024,
        line_length = 1.5 * 1024 * 1024,
      },
      dashboard = {
        sections = {
          { section = "header" },
          { title = "MRU ",           file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
          { section = "recent_files", cwd = true,                           limit = 8,  padding = 1 },
          { title = "MRU",            padding = 1 },
          { section = "recent_files", limit = 8,                            padding = 1 },
          { section = "startup" },
        }
      },
      indent = {
        animate = { enabled = false },
        scope = { enabled = true },
        filter = function(buf)
          local exclude = { 'oil', 'bigfile' }
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
            return false
          end
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
      input = {},
      git = {},
      gitbrowse = {},
      lazygit = {},
      image = {},
      quickfile = {},
      picker = {
        win = {
          -- input window
          input = {
            keys = {
              ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
              ["<Tab>"] = { "list_down", mode = { "i", "n" } },
              ["<c-j>"] = { "select_and_next", mode = { "i", "n" } },
              ["<c-k>"] = { "select_and_prev", mode = { "i", "n" } },
            },

          },
          -- result list window
          list = {
            keys = {
              ["<S-Tab>"] = "list_up",
              ["<Tab>"] = "list_down",
              ["<c-j>"] = { "select_and_next", mode = { "n", "x" } },
              ["<c-k>"] = { "select_and_prev", mode = { "n", "x" } },
            },
          },
        },
      },
      scope = {},
      scratch = {},
      statuscolumn = {},
      words = {},
      zen = {},
    },
    keys = {
      -- Buffer quit
      { "<leader>qq",      function() Snacks.bufdelete() end,                                      desc = "[Q]uit current buffer" },
      { "<leader>qa",      function() Snacks.bufdelete.all() end,                                  desc = "[Q]uit [a]ll buffers" },
      { "<leader>qo",      function() Snacks.bufdelete.other() end,                                desc = "[Q]uit [o]ther buffers" },
      -- Zen
      { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      -- Git
      { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",                  mode = { "n", "v" } },
      { "<leader>gb",      function() Snacks.git.blame_line() end,                                 desc = "Git Blame Line" },
      { "<leader>gf",      function() Snacks.lazygit.log_file() end,                               desc = "Lazygit Current File History" },
      { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
      { "<leader>gl",      function() Snacks.lazygit.log() end,                                    desc = "Lazygit Log (cwd)" },
      -- Note
      { "<leader>na",      function() Snacks.scratch() end,                                        desc = "[N]ote [a]dd" },
      { "<leader>ns",      function() Snacks.scratch.select() end,                                 desc = "[N]ote [s]elect" },
      -- Search
      { '<leader><space>', function() Snacks.picker.smart({ hidden = true }) end,                                   desc = "Smart Search Files" },
      { "<leader>-",       function() Snacks.picker.files({ hidden = true }) end,                  desc = "Search Files" },
      { "<leader>.",       function() Snacks.picker.recent() end,                                  desc = "Recent" },
      { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
      { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<leader>sb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      { "<leader>sf",      function() Snacks.picker.files() end,                                   desc = "Search Files" },
      { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>sG",      function() Snacks.picker.git_files() end,                               desc = "Search Git Files" },
      { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sN",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search Config File" },
      { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
      { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word",    mode = { "n", "x" } },
      -- LSP
      { "grd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto [D]efinition" },
      { "grD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto [D]eclaration" },
      { "grr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                        desc = "[R]eferences" },
      { "gri",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto [I]mplementation" },
      { "gry",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
      { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  }
}
