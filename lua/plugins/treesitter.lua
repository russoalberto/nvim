local ensure_installed = {
  'angular',
  'astro',
  'bash',
  'c',
  'c_sharp',
  'caddy',
  'dockerfile',
  'hcl',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'php',
  'prisma',
  'regex',
  'scss',
  'sql',
  'terraform',
  'tsx',
  'twig',
  'typescript',
  'yaml',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  event = { 'BufReadPre', 'BufNewFile' },
  build = false,
  config = function()
    local ts_config = require 'nvim-treesitter.config'
    ts_config.setup {}

    -- Install missing parsers
    local already_installed = ts_config.get_installed 'parsers'
    local to_install = {}
    for _, parser in ipairs(ensure_installed) do
      if not vim.tbl_contains(already_installed, parser) then
        to_install[#to_install + 1] = parser
      end
    end
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    -- Enable treesitter-based folding and indentation per filetype.
    -- Must call vim.treesitter.start() first so parser is attached
    -- before setting foldexpr/indentexpr.
    local installed = ts_config.get_installed 'parsers'
    for _, parser in ipairs(installed) do
      local filetypes = vim.treesitter.language.get_filetypes(parser)
      if filetypes and #filetypes > 0 then
        vim.api.nvim_create_autocmd('FileType', {
          pattern = filetypes,
          callback = function()
            pcall(vim.treesitter.start)
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = 'expr'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end
    end

    -- Trigger for current buffer (FileType already fired before config ran)
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if ft ~= '' then
      local lang = vim.treesitter.language.get_lang(ft)
      if lang then
        pcall(vim.treesitter.start, bufnr, lang)
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = 'expr'
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end
  end,
}
