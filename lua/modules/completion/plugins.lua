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
completion['hrsh7th/nvim-compe'] = {
    opt = true,
    event = 'InsertEnter',
    after = 'nvim-lspconfig',
    config = conf.compe
}
completion['nvim-lua/lsp_extensions.nvim'] = {
    opt = true,
    after = 'nvim-lspconfig'
}
completion['ray-x/lsp_signature.nvim'] = {opt = true, after = 'nvim-lspconfig'}
completion['tzachar/compe-tabnine'] = {
    opt = true,
    after = 'nvim-compe',
    run = './install.sh'
}
completion['hrsh7th/vim-vsnip-integ'] = {
    opt = true,
    after = 'nvim-compe',
    requires = {'hrsh7th/vim-vsnip', opt = true, event = 'InsertCharPre'}
}
completion['rafamadriz/friendly-snippets'] = {opt = true, after = 'nvim-compe'}
completion['SirVer/ultisnips'] = {
    opt = true,
    after = 'nvim-compe',
    requires = {'honza/vim-snippets', opt = true}
}
completion['windwp/nvim-autopairs'] = {
    opt = true,
    event = 'InsertCharPre',
    after = 'nvim-lspconfig',
    config = conf.autopairs
}
return completion
