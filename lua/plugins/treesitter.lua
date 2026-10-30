local ensure_installed = {
  'angular',
  'bash',
  'c_sharp',
  'caddy',
  'css',
  'dockerfile',
  'hcl',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'prisma',
  'regex',
  'scss',
  'sql',
  'terraform',
  'tsx',
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

    local function enable(bufnr, ft)
      local lang = vim.treesitter.language.get_lang(ft)
      if not lang then
        return
      end
      if not pcall(vim.treesitter.start, bufnr, lang) then
        return
      end
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = 'expr'
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        enable(args.buf, args.match)
      end,
    })

    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if ft ~= '' then
      enable(bufnr, ft)
    end
  end,
}
