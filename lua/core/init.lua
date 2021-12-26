local global = require "core.global"
local vim = vim

-- Create cache dir and subs dir
local createdir = function()
    local data_dir = {
        global.cache_dir .. "backup",
        global.cache_dir .. "session",
        global.cache_dir .. "swap",
        global.cache_dir .. "tags",
        global.cache_dir .. "undo"
    }
    -- There only check once that If cache_dir exists
    -- Then I don't want to check subs dir exists
    if vim.fn.isdirectory(global.cache_dir) == 0 then
        -- NOTE: not compatible with windows
        os.execute("mkdir -p " .. global.cache_dir)
        for _, v in pairs(data_dir) do
            if vim.fn.isdirectory(v) == 0 then
                os.execute("mkdir -p " .. v)
            end
        end
    end
end

local disable_distribution_plugins = function()
    vim.g.loaded_fzf = 1
    vim.g.loaded_gtags = 1
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
end

local leader_map = function()
    vim.g.mapleader = ";"
    vim.api.nvim_set_keymap("n", " ", "", {noremap = true})
    vim.api.nvim_set_keymap("x", " ", "", {noremap = true})
    vim.api.nvim_set_keymap("n", "\\", ";", {noremap = true})
end

local dashboard_config = function()
    vim.g.dashboard_footer_icon = "🐬 "
    vim.g.dashboard_default_executive = "telescope"

    vim.g.dashboard_custom_header = {
        [[              ...  .......          ]],
        [[         ....................       ]],
        [[    ..'........................     ]],
        [[ ...,'.......'.., .........'....    ]],
        [[  .'......,. ;'., '..'.......'.'.   ]],
        [[ .'.,'.''.;..,'.. .  ...'....','..  ]],
        [[..''.'.''''.....        .,'....;'.. ]],
        [[..',.......'. .        ..';'..','...]],
        [[ ....''..  ..        .....;,..','...]],
        [[  . .....           ......,..';,....]],
        [[      .'.         ....  ... ,,'.....]],
        [[      .,..             .....,'..... ]],
        [[     .'''.             ...'......   ]],
        [[     ..'..'.          ... ......    ]],
        [[       . '.'..             ..       ]],
        [[         ......           .         ]],
        [[            ....                    ]]
    }

    vim.g.dashboard_custom_section = {
        change_colorscheme = {
            description = {" Scheme change              semicollon s c "},
            command = "DashboardChangeColorscheme"
        },
        find_frecency = {
            description = {" File frecency              semicollon f r "},
            command = "Telescope frecency"
        },
        find_history = {
            description = {" File history               semicollon f e "},
            command = "DashboardFindHistory"
        },
        find_project = {
            description = {" Project find               semicollon f p "},
            command = "Telescope project"
        },
        find_file = {
            description = {" File find                  semicollon f f "},
            command = "DashboardFindFile"
        },
        file_new = {
            description = {" File new                   semicollon f n "},
            command = "DashboardNewFile"
        },
        find_word = {
            description = {" Word find                  semicollon f w "},
            command = "DashboardFindWord"
        }
    }
end

local load_core = function()
    createdir()
    disable_distribution_plugins()
    leader_map()

    local pack = require("core.pack")
    pack.ensure_plugins()
    require("core.options")
    require("core.mapping")
    require("core.event")
    require("keymap")
    pack.load_compile()
    dashboard_config()

    vim.cmd [[colorscheme catppuccin]]
end

load_core()
