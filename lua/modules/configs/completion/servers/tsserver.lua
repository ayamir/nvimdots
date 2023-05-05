local util = require 'lspconfig.util'

return {
  cmd = { "typescript-language-server --stdio" },
  init_options = { hostInfo = 'neovim' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(fname)
    return util.root_pattern 'tsconfig.json'(fname)
      or util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
  end,
  single_file_support = true,
}
