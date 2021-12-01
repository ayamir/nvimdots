local global = require "core.global"
local vim = vim

-- Create cache dir and subs dir
local createdir = function()
    local data_dir = {
        global.cache_dir .. "backup", global.cache_dir .. "session",
        global.cache_dir .. "swap", global.cache_dir .. "tags",
        global.cache_dir .. "undo"
    }
    -- There only check once that If cache_dir exists
    -- Then I don't want to check subs dir exists
    if vim.fn.isdirectory(global.cache_dir) == 0 then
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
    vim.g.did_load_filetypes = 1
end

local leader_map = function()
    vim.g.mapleader = ","
    vim.api.nvim_set_keymap("n", " ", "", {noremap = true})
    vim.api.nvim_set_keymap("x", " ", "", {noremap = true})
end

local neovide_config = function()
    vim.cmd [[set guifont=JetBrainsMono\ Nerd\ Font:h12]]
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_no_idle = true
    vim.g.neovide_cursor_animation_length = 0.03
    vim.g.neovide_cursor_trail_length = 0.05
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_vfx_opacity = 200.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
    vim.g.neovide_cursor_vfx_particle_speed = 20.0
    vim.g.neovide_cursor_vfx_particle_density = 5.0
end

local dashboard_config = function()
    vim.g.dashboard_footer_icon = "🍚 🎮"
    vim.g.dashboard_default_executive = "telescope"

    vim.g.dashboard_custom_header = {
        [[                                               ..':cllllc:lc:cc:.                            ]],
        [[                                            .kNWWWWNKKKKXKKKKKKKK:                           ]],
        [[                      .;d.              ,OWWWWWWWXKKKKXXKKKKXKK.                             ]],
        [[                      d0K.             xNWWWWWWNNXKKKKKKKKKXXX'                              ]],
        [[                       cXk            .x0XNNWWNNNXKKKKKKKXXNWk                               ]],
        [[                        .k'.          .kWWWWNWWWNXXKKKKKXNNNl                                ]],
        [[                          ..          ',cdk00KNWWWNNNWNKKKK,     ,cddol,                     ]],
        [[                           ....   ...xXXK0Oxco:,;cx0XKKK00'  :dO0000KXNNxc::;'               ]],
        [[                           ...''..'':ldollll,,::,,;;:loxo. cKKKXKKXXXNWWWWWWWWNd.            ]],
        [[                    ......''''',,,,;:,;;;,,:,,;,,:ccl:;:::cOKKkNWWWNWWWWWWWWWWWW;            ]],
        [[                  .....',,,;;;;,;,,,,;;,;,',,;;;;dkkxxdll;,;c:xOkkXWWWWWWWWWWWWWK'           ]],
        [[              .......''.....,;,';,;;:c:c:,;coxkkxxxxxxxxdoc:::ldWxcd0KXXWWWWWWWWWN0,         ]],
        [[        ..cdoc:    .'      ..';;',,dOO0xo:okO0000000Oxodddoooc:;;ccdWNX0oKWWWWWWNK00k        ]],
        [[          KKKKKx.  .  .,;:c;;:ccc;.,k0l;:dk000K000O000kxxddlllolc:;;:oc:OKXXXXXXKOOOOk;      ]],
        [[         .k:xkddd. ...,'':::cccc;'xOd:,;dOxkO00K000X00kddxkxd0KkdO00xd0dcoOOOO00Okkkkkkd.    ]],
        [[         ';  coc,'',,;;;:cccccc;',;;.';:xkkKOdxO00KK00OdlldOkxxkkOkloXXO:lOOO00Okxkxkk;      ]],
        [[         '.   .:oo;,,;:,c; .:;',;:c,..,;cdxKdok0XXX000OkdcoooollccccooolxOkkkkkxdxOxc.       ]],
        [[         .     .:c',,,  c,;c,.:dOKXo,..',:lOKXXXXX0KOkxxxkkdlodoodxkOOOkxxxxxl:;...          ]],
        [[        ..       .',',.';:c,..kXO0KOOxx:,,',kKXXKKK0xoOXXXXXX00Okk0Oxoc;;,,.                 ]],
        [[        .         ..'',,;:'..cXXXOxlcoxx','.,,lo0kxldKXXNNNXXXX0k;.                          ]],
        [[        .          ...'',.  'OXXXKlclllx'.....;::ccxXNNNNNXXXXXXX;,.                         ]],
        [[                      ...  .:XXXX0cclllo;. .'..':lOXNNNNXXKKXXXXXOOOxod.                     ]],
        [[                        . .oOKXXXkdlclllc;.:'  .:0XXXXXK000KXXXXXOxxdoll:                    ]],
        [[            ..'''...      :ddoooc:dxxOkkOx;;  ':coOXKO0KXXXXXNXXX0llccc::.                   ]],
        [[           ....',,,''..  .:dXXKk:okOOXkl,.....,;'..;cxKXXXXXXNXXXKcc:::;;,                   ]],
        [[            .....'',,;''.,:dKKdl;ccclxodx:.oK0Ol;'...lkO0KXXNXXXX0c::;;,,,                   ]],
        [[             ..'...'',,..;:OKo,,,:,...XXXKx,,:;;;;.  .:k0KXXNNXXXkcc::;;,'                   ]],
        [[              .......'. .;:Ko;,'....'dXXOO:.  .;,,;....c0XXXXXXXKc;:;;;;,,.                  ]],
        [[              ..... .. .',:l;cxkoodx0000O: '    '''';,,:l0XXXXXXo''',,,'''.                  ]],
        [[               ....    ...'lOXXox00O0X0l; ';     .':dOdlllOXXXXo''.......                    ]],
        [[                ....   ...OXX0d,';KXXXXk;'c;'.....:k0KXOllk0K0:.........                     ]],
        [[                ....  ..;oOdc:,'..cOXXXX0olc;:::::coKXXXKoKl,.............                   ]],
        [[                 ..  ..,;c,;::,. .::xXXXXKd:ccllcccllkXXXXx.   ...........                   ]],
        [[                    ..'..'.....'..:::oO0KK0xcc::::::::oOl'      ..........                   ]],
        [[                   ...... .. .... ';::,...,:;,;;;;;;;'.  .        ........                   ]],
        [[                  .....    '    .....,,,....',,,,'..                                         ]],
        [[                  ..   .   .          ......                                                 ]],
        [[                      ..                                                                     ]],
        [[                      ...                                                                    ]],
        [[                       ..                                                                    ]],
        [[                         .                                                                   ]],
    }

    vim.g.dashboard_custom_section = {
        change_colorscheme = {
            description = {" Scheme change              comma s c "},
            command = "DashboardChangeColorscheme"
        },
        find_frecency = {
            description = {" File frecency              comma f r "},
            command = "Telescope frecency"
        },
        find_history = {
            description = {" File history               comma f e "},
            command = "DashboardFindHistory"
        },
        find_project = {
            description = {" Project find               comma f p "},
            command = "Telescope project"
        },
        find_file = {
            description = {" File find                  comma f f "},
            command = "DashboardFindFile"
        },
        file_new = {
            description = {" File new                   comma f n "},
            command = "DashboardNewFile"
        },
        find_word = {
            description = {" Word find                  comma f w "},
            command = "DashboardFindWord"
        }
    }
end

local clipboard_settings = function()
    vim.cmd [[
    let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }

    ]]
end

local function scrollbar()
    vim.g.scrollbar_max_size = 10
    vim.g.scrollbar_mni_size = 3
    vim.g.scrollbar_excluded_filetypes = {"NvimTree", "SymbolsOutline"}
    vim.g.scrollbar_width = 1
    vim.g.scrollbar_winblend = 0
end

local load_core = function()
    local pack = require("core.pack")
    createdir()
    disable_distribution_plugins()
    leader_map()

    pack.ensure_plugins()
    neovide_config()
    dashboard_config()
    -- clipboard_settings()

    require("core.options")
    require("core.mapping")
    require("keymap")
    require("core.event")
    pack.load_compile()

    vim.cmd [[colorscheme edge]]
end

load_core()
