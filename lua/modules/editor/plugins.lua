local editor = {}
local conf = require('modules.editor.config')

editor['junegunn/vim-easy-align'] = {opt = true, cmd = 'EasyAlign'}
editor['itchyny/vim-cursorword'] = {
    opt = true,
    event = {'BufReadPre', 'BufNewFile'},
    config = conf.vim_cursorwod
}
editor['tpope/vim-commentary'] = {opt = true, cmd = 'Commentary'}
editor['simrat39/symbols-outline.nvim'] = {
    opt = true,
    cmd = {'SymbolsOutline', 'SymbolsOulineOpen'},
    config = conf.symbols_outline
}
editor['nvim-treesitter/nvim-treesitter'] = {
    opt = true,
    run = ':TSUpdate',
    event = 'BufRead',
    after = 'telescope.nvim',
    config = conf.nvim_treesitter
}
editor['nvim-treesitter/nvim-treesitter-textobjects'] = {
    opt = true,
    after = 'nvim-treesitter'
}
editor['p00f/nvim-ts-rainbow'] = {opt = true}
editor['sbdchd/neoformat'] = {opt = true, cmd = 'Neoformat'}
editor['windwp/nvim-ts-autotag'] = {
    opt = true,
    ft = {'html', 'xml'},
    config = conf.autotag
}
editor['rhysd/accelerated-jk'] = {opt = true}
editor['hrsh7th/vim-eft'] = {opt = true}
editor['easymotion/vim-easymotion'] = {opt = true, config = conf.easymotion}
editor['vimlab/split-term.vim'] = {
    opt = true,
    cmd = {'Term', 'VTerm'},
    config = conf.split_term
}
editor['thinca/vim-quickrun'] = {opt = true, cmd = {'QuickRun', 'Q'}}
editor['norcalli/nvim-colorizer.lua'] = {
    ft = {'html', 'css', 'sass', 'vim', 'typescript', 'typescriptreact'},
    config = conf.nvim_colorizer
}

return editor
