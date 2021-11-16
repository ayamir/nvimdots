local tools = {}
local conf = require("modules.tools.config")

tools["nvim-lua/plenary.nvim"] = {
    opt = false
}
tools["nvim-telescope/telescope.nvim"] = {
    opt = true,
    cmd = "Telescope",
    config = conf.telescope,
    requires = {
        {"nvim-lua/plenary.nvim", opt = false},
        {"nvim-lua/popup.nvim", opt = true}
    }
}
tools["nvim-telescope/telescope-fzy-native.nvim"] = {
    opt = true,
    after = "telescope.nvim"
}

tools["nvim-telescope/telescope-project.nvim"] = {
    opt = true,
    after = "telescope.nvim"
}
tools["nvim-telescope/telescope-frecency.nvim"] = {
    opt = true,
    after = "telescope.nvim",
    requires = {{"tami5/sql.nvim", opt = true}}
}
tools["nvim-telescope/telescope-media-files.nvim"] = {
    opt = true,
    after = "telescope.nvim"
}
tools["jvgrootveld/telescope-zoxide"] = {opt = true, after = "telescope.nvim"}
tools["thinca/vim-quickrun"] = {opt = true, cmd = {"QuickRun", "Q"}}
tools["michaelb/sniprun"] = {
    opt = true,
    run = "bash ./install.sh",
    cmd = {"SnipRun", "'<,'>SnipRun"}
}
tools["folke/which-key.nvim"] = {
    opt = true,
    keys = ",",
    config = function()
        require("which-key").setup {}
    end
}
tools["folke/trouble.nvim"] = {
    opt = true,
    cmd = {"Trouble", "TroubleToggle", "TroubleRefresh"},
    config = conf.trouble
}
tools["dstein64/vim-startuptime"] = {opt = true, cmd = "StartupTime"}
tools["gelguy/wilder.nvim"] = {
    event = "CmdlineEnter",
    config = conf.wilder,
    requires = {{"romgrk/fzy-lua-native", after = "wilder.nvim"}}
}
tools["nathom/filetype.nvim"] = {opt = false}
return tools
