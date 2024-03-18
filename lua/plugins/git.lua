return {
  {
    'lewis6991/gitsigns.nvim',
    event  = { 'BufReadPost', 'BufNewFile' },
    opts   = {
      current_line_blame = true
    },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']g', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Next hunk' })

          map('n', '[g', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Prev hunk' })

          -- Normal mode actions
          map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
          map('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>gd', gs.diffthis, { desc = 'Diff line' })
          map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'Diff buffer' })

          -- Visual mode actions
          map('v', 'gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = 'Stage selected hunks' })
          map('v', 'gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = 'Reset selected hunks' })
        end
      }
    end
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
