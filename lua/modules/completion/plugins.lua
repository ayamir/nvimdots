local completion = {}
local conf = require('modules.completion.config')

completion['neovim/nvim-lspconfig'] = {
    opt = true,
    event = 'BufRead',
    config = conf.nvim_lsp
}
completion['kabouzeid/nvim-lspinstall'] = {opt = true, after = 'nvim-lspconfig'}
completion['glepnir/lspsaga.nvim'] = {
    opt = true,
    after = 'nvim-lspconfig',
    config = conf.saga
}
completion['ray-x/lsp_signature.nvim'] = {opt = true, after = 'nvim-lspconfig'}
completion['hrsh7th/nvim-cmp'] = {
    config = conf.cmp,
    event = 'InsertEnter',
    requires = {
        {'saadparwaiz1/cmp_luasnip', after = 'LuaSnip'},
        {'hrsh7th/cmp-buffer', after = 'cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lsp', after = 'cmp-buffer'},
        {'hrsh7th/cmp-nvim-lua', after = 'cmp-nvim-lsp'},
        {'andersevenrud/compe-tmux', branch = 'cmp', after = 'cmp-nvim-lua'},
        {'hrsh7th/cmp-path', after = 'compe-tmux'}, {
            'quangnguyen30192/cmp-nvim-tags',
            after = 'cmp-path',
            ft = {'go', 'python', 'rust', 'lua'}
        }, {'f3fora/cmp-spell', after = 'cmp-nvim-tags'}
        -- {
        --     'tzachar/cmp-tabnine',
        --     run = './install.sh',
        --     after = 'cmp-spell',
        --     config = conf.tabnine
        -- }
    }
}
completion['L3MON4D3/LuaSnip'] = {
    after = 'nvim-cmp',
    config = conf.luasnip,
    requires = 'rafamadriz/friendly-snippets'
}
completion['windwp/nvim-autopairs'] = {
    after = 'nvim-cmp',
    config = conf.autopairs
}

return completion
