local lang = {}
local conf = require('modules.lang.config')

lang['fatih/vim-go'] = {
    opt = true,
    ft = 'go',
    run = ':GoInstallBinaries',
    config = conf.go
}
lang['rust-lang/rust.vim'] = {opt = true, ft = "rust", config = conf.rust}
lang['kristijanhusak/orgmode.nvim'] = {
    opt = true,
    ft = "org",
    config = conf.org
}
lang['iamcco/markdown-preview.nvim'] = {
    run = 'cd app && yarn install',
    cmd = {'MarkdownPreview', 'MarkdownPreviewToggle'},
    config = conf.markdown
}
return lang
