local completion = {}
local conf = require('modules.completion.config')

completion['neovim/nvim-lspconfig'] = {
    opt = true,
    event = 'BufRead',
    config = conf.nvim_lsp
}
completion['kabouzeid/nvim-lspinstall'] = {
    opt = true,
    cmd = {'LspInstall', 'LspUninstall'}
}
completion['onsails/lspkind-nvim'] = {
    opt = true,
    event = 'BufRead',
    config = conf.lspkind
}
completion['glepnir/lspsaga.nvim'] = {
    opt = true,
    cmd = 'Lspsaga',
    config = conf.saga
}
completion['ray-x/lsp_signature.nvim'] = {opt = true, after = 'nvim-lspconfig'}
completion['hrsh7th/nvim-cmp'] = {
    opt = false,
    config = conf.cmp,
    after = 'nvim-lspconfig',
    requires = {
        {'hrsh7th/cmp-buffer', after = 'nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'},
        {'andersevenrud/compe-tmux', after = 'nvim-cmp'},
        {'hrsh7th/cmp-path', after = 'nvim-cmp'},
        {'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'},
        {'quangnguyen30192/cmp-nvim-ultisnips', after = 'nvim-cmp'},
        {'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp'},
        {'f3fora/cmp-spell', after = 'nvim-cmp'},
        {'tzachar/cmp-tabnine', run = './install.sh', after = 'nvim-cmp'}
    }
}
completion['hrsh7th/vim-vsnip-integ'] = {
    opt = true,
    after = 'nvim-cmp',
    requires = {'hrsh7th/vim-vsnip', opt = true, event = 'InsertCharPre'}
}
completion['rafamadriz/friendly-snippets'] = {opt = true, after = 'nvim-cmp'}
completion['SirVer/ultisnips'] = {
    opt = true,
    after = 'nvim-cmp',
    requires = {'honza/vim-snippets', opt = true}
}
completion['windwp/nvim-autopairs'] = {
    opt = true,
    event = 'InsertCharPre',
    after = 'nvim-cmp',
    config = conf.autopairs
}

return completion
