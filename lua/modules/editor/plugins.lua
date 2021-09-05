local editor = {}
local conf = require('modules.editor.config')

editor['junegunn/vim-easy-align'] = {opt = true, cmd = 'EasyAlign'}
editor['itchyny/vim-cursorword'] = {
    opt = true,
    event = {'BufReadPre', 'BufNewFile'},
    config = conf.vim_cursorwod
}
editor['terrortylor/nvim-comment'] = {
    opt = false,
    config = function() require('nvim_comment').setup({
        hook = function()
            require("ts_context_commentstring.internal").update_commentstring()
        end,
    }) end
}
editor['simrat39/symbols-outline.nvim'] = {
    opt = true,
    cmd = {'SymbolsOutline', 'SymbolsOulineOpen'},
    config = conf.symbols_outline
}
editor['nvim-treesitter/nvim-treesitter'] = {
    opt = true,
    run = ':TSUpdate',
    event = 'BufRead',
    config = conf.nvim_treesitter
}
editor['nvim-treesitter/nvim-treesitter-textobjects'] = {
    opt = true,
    after = 'nvim-treesitter'
}
editor['romgrk/nvim-treesitter-context'] = {
    opt = true,
    after = 'nvim-treesitter'
}
editor['p00f/nvim-ts-rainbow'] = {
    opt = true,
    after = 'nvim-treesitter',
    event = 'BufRead'
}
editor['JoosepAlviste/nvim-ts-context-commentstring'] = {
    opt = true,
    after = 'nvim-treesitter'
}
editor['SmiteshP/nvim-gps'] = {
    opt = true,
    after = 'nvim-treesitter',
    config = conf.nvim_gps
}
editor['sbdchd/neoformat'] = {opt = true, cmd = 'Neoformat'}
editor['windwp/nvim-ts-autotag'] = {
    opt = true,
    ft = {'html', 'xml'},
    config = conf.autotag
}
editor['andymass/vim-matchup'] = {
    opt = true,
    after = 'nvim-treesitter',
    config = conf.matchup
}
editor['rhysd/accelerated-jk'] = {opt = true}
editor['hrsh7th/vim-eft'] = {opt = true}
editor['romainl/vim-cool'] = {
    opt = true,
    event = {'CursorMoved', 'InsertEnter'}
}
editor['easymotion/vim-easymotion'] = {opt = true, config = conf.easymotion}
editor['karb94/neoscroll.nvim'] = {
    opt = true,
    event = "WinScrolled",
    config = conf.neoscroll
}
editor['vimlab/split-term.vim'] = {opt = true, cmd = {'Term', 'VTerm'}}
editor['akinsho/nvim-toggleterm.lua'] = {
    opt = true,
    event = 'BufRead',
    config = conf.toggleterm
}
editor['norcalli/nvim-colorizer.lua'] = {
    opt = true,
    event = 'BufRead',
    config = conf.nvim_colorizer
}
editor['rmagatti/auto-session'] = {
    opt = true,
    cmd = {'SaveSession', 'RestoreSession', 'DeleteSession'},
    config = conf.auto_session
}
editor['jdhao/better-escape.vim'] = {
    opt = true,
    event = 'InsertEnter'
}
editor['rcarriga/nvim-dap-ui'] = {
    opt = false,
    config = conf.dapui,
    requires = {
        {'mfussenegger/nvim-dap', config = conf.dap}, {
            'Pocco81/DAPInstall.nvim',
            opt = true,
            cmd = {'DIInstall', 'DIUninstall', 'DIList'},
            config = conf.dapinstall
        }
    }
}

return editor
