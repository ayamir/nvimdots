local tools = {}
local conf = require('modules.tools.config')

tools['nvim-telescope/telescope.nvim'] = {
    opt = true,
    cmd = 'Telescope',
    config = conf.telescope,
    requires = {
        {'nvim-lua/popup.nvim', opt = true},
        {'nvim-lua/plenary.nvim', opt = true}
    }
}
tools['nvim-telescope/telescope-fzy-native.nvim'] = {
    opt = true,
    after = 'telescope.nvim'
}

tools['nvim-telescope/telescope-project.nvim'] = {
    opt = true,
    after = 'telescope.nvim'
}
tools['nvim-telescope/telescope-frecency.nvim'] = {
    opt = true,
    after = 'telescope.nvim',
    requires = {{'tami5/sql.nvim', opt = true}}
}
tools['folke/which-key.nvim'] = {
    config = function() require("which-key").setup {} end
}
tools['folke/trouble.nvim'] = {
    opt = true,
    cmd = {"Trouble", "TroubleToggle", "TroubleRefresh"},
    config = conf.trouble
}
tools['dstein64/vim-startuptime'] = {opt = true, cmd = "StartupTime"}

return tools
