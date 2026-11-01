return {
  'GustavEikaas/easy-dotnet.nvim',
  cmd = 'Dotnet',
  event = {
    'BufReadPre *.cs',
    'BufNewFile *.cs',
    'BufReadPre *.csproj',
    'BufNewFile *.csproj',
    'BufReadPre *.sln',
    'BufNewFile *.sln',
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    lsp = {
      enabled = true,
      preload_roslyn = true,
      roslynator_enabled = true,
      easy_dotnet_analyzer_enabled = true,
      capabilities = {
        definitionProvider = true,
        referencesProvider = true,
      },
      settings = {
        ['dotnet|roslyn'] = {
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
          include_prerelease_sdks = true,
          enable_decompilation_support = true,
        },
      },
    },
  },
}
