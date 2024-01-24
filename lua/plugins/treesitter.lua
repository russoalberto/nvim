local is_large_file = function(_, buf)
  local max_filesize = 1000 * 1024 -- 1000 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'bash',
        'c_sharp',
        'cpp',
        'dockerfile',
        'go',
        'html',
        'javascript',
        'json',
        'php',
        'prisma',
        'regex',
        'rust',
        'scss',
        'tsx',
        'typescript',
        'yaml',
      },
      highlight = {
        enable = true,
        disable = is_large_file,
      },
      indent = { enable = true }
    }
  end,
}
