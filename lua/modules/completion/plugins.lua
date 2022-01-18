local completion = {}
local conf = require("modules.completion.config")

-- tag function
completion["weilbith/nvim-lsp-smag"] = {}

completion["neovim/nvim-lspconfig"] = {
    config = conf.nvim_lsp
}

-- lsp installer
completion["williamboman/nvim-lsp-installer"] = {
    opt = true,
    after = "nvim-lspconfig"
}

-- lsp ui
completion["tami5/lspsaga.nvim"] = {
    opt = true,
    after = "nvim-lspconfig"
}

completion["kosayoda/nvim-lightbulb"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.lightbulb
}

completion["ray-x/lsp_signature.nvim"] = {
    opt = true,
    after = "nvim-lspconfig"
}

completion["hrsh7th/nvim-cmp"] = {
    config = conf.cmp,
    event = "InsertEnter",
    requires = {
        {"lukas-reineke/cmp-under-comparator"},
        {"saadparwaiz1/cmp_luasnip", after = "LuaSnip"},
        {"hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip"},
        {"hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp"},
        {"andersevenrud/cmp-tmux", branch = "compe", after = "cmp-nvim-lua"},
        {"hrsh7th/cmp-path", after = "cmp-tmux"},
        {"f3fora/cmp-spell", after = "cmp-path"},
        {"hrsh7th/cmp-buffer", after = "cmp-spell"},
        {"kdheepak/cmp-latex-symbols", after = "cmp-buffer"},
        {"uga-rosa/cmp-dictionary", after = "cmp-latex-symbols"}
        -- {
        --     'tzachar/cmp-tabnine',
        --     run = './install.sh',
        --     after = 'cmp-spell',
        --     config = conf.tabnine
        -- }
    }
}

completion["uga-rosa/cmp-dictionary"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.dictionary
}

completion["L3MON4D3/LuaSnip"] = {
    after = "nvim-cmp",
    config = conf.luasnip,
    requires = "rafamadriz/friendly-snippets"
}

completion["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = conf.autopairs
}

completion["github/copilot.vim"] = {opt = true, cmd = "Copilot"}

return completion
