local config = {}
local global = require('core.global')
local session_dir = global.data_dir .. '/session'

if vim.fn.isdirectory(session_dir) ~= 1 then
    os.execute('mkdir -p ' .. session_dir)
end

function config.symbols_outline()
    vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = true,
        position = 'right',
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        keymaps = {
            close = "<Esc>",
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            rename_symbol = "r",
            code_actions = "a"
        },
        lsp_blacklist = {},
        symbols = {
            File = {icon = "", hl = "TSURI"},
            Module = {icon = "", hl = "TSNamespace"},
            Namespace = {icon = "", hl = "TSNamespace"},
            Package = {icon = "", hl = "TSNamespace"},
            Class = {icon = "𝓒", hl = "TSType"},
            Method = {icon = "ƒ", hl = "TSMethod"},
            Property = {icon = "", hl = "TSMethod"},
            Field = {icon = "", hl = "TSField"},
            Constructor = {icon = "", hl = "TSConstructor"},
            Enum = {icon = "ℰ", hl = "TSType"},
            Interface = {icon = "ﰮ", hl = "TSType"},
            Function = {icon = "", hl = "TSFunction"},
            Variable = {icon = "", hl = "TSConstant"},
            Constant = {icon = "", hl = "TSConstant"},
            String = {icon = "𝓐", hl = "TSString"},
            Number = {icon = "#", hl = "TSNumber"},
            Boolean = {icon = "⊨", hl = "TSBoolean"},
            Array = {icon = "", hl = "TSConstant"},
            Object = {icon = "⦿", hl = "TSType"},
            Key = {icon = "🔐", hl = "TSType"},
            Null = {icon = "NULL", hl = "TSType"},
            EnumMember = {icon = "", hl = "TSField"},
            Struct = {icon = "𝓢", hl = "TSType"},
            Event = {icon = "🗲", hl = "TSType"},
            Operator = {icon = "+", hl = "TSOperator"},
            TypeParameter = {icon = "𝙏", hl = "TSParameter"}
        }
    }
end

function config.vim_cursorwod()
    vim.api.nvim_command('augroup user_plugin_cursorword')
    vim.api.nvim_command('autocmd!')
    vim.api.nvim_command(
        'autocmd FileType NvimTree,lspsagafinder,dashboard let b:cursorword = 0')
    vim.api.nvim_command(
        'autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif')
    vim.api.nvim_command('autocmd InsertEnter * let b:cursorword = 0')
    vim.api.nvim_command('autocmd InsertLeave * let b:cursorword = 1')
    vim.api.nvim_command('augroup END')
end

function config.nvim_treesitter()
    vim.api.nvim_command('set foldmethod=expr')
    vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')

    require'nvim-treesitter.configs'.setup {
        ensure_installed = {
            "c", "cpp", "go", "gomod", "rust", "bash", "lua", "toml", "yaml",
            "json", "python", "javascript", "typescript", "html"
        },
        ignore_install = {
            "beancount", "bibtex", "c_sharp", "clojure", "comment",
            "commonlisp", "cuda", "dart", "devicetree", "elixir", "erlang",
            "fennel", "Godot", "glimmer", "graphql", "java", "jsdoc", "julia",
            "kotlin", "ledger", "nix", "ocaml", "ocaml_interface", "php", "ql",
            "query", "r", "rst", "ruby", "scss", "sparql", "supercollider",
            "svelte", "teal", "tsx", "turtle", "verilog", "vue", "zig"
        },
        highlight = {enable = true, disable = {'vim'}},
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["of"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["oc"] = "@class.outer",
                    ["ic"] = "@class.inner"
                }
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer"
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer"
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer"
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer"
                }
            }
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000 -- Do not enable for files with more than 1000 lines, int
        }
    }
end

function config.autotag()
    require('nvim-ts-autotag').setup({
        filetypes = {
            "html", "xml", "javascript", "typescriptreact", "javascriptreact",
            "vue"
        }
    })
end

function config.nvim_colorizer() require('colorizer').setup() end

function config.easymotion()
    vim.g.EasyMotion_do_mapping = 0
    vim.g.EasyMotion_smartcase = 1
    vim.g.EasyMotion_use_smartsign_us = 1
end

function config.neoscroll()
    require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = {
            '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz',
            'zb'
        },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil -- Function to run after the scrolling animation ends
    })
end

function config.auto_session()
    local opts = {
        log_level = 'info',
        auto_session_enable_last_session = true,
        auto_session_root_dir = session_dir,
        auto_session_enabled = true,
        auto_save_enabled = nil,
        auto_restore_enabled = nil,
        auto_session_suppress_dirs = nil
    }

    require('auto-session').setup(opts)
end

return config
