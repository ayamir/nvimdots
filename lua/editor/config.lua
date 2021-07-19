local config = {}

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
            "json"
        },
        ignore_install = {
            "javascript", "beancount", "bibtex", "c_sharp", "clojure",
            "comment", "commonlisp", "cuda", "dart", "devicetree", "elixir",
            "erlang", "fennel", "Godot", "glimmer", "graphql", "java", "jsdoc",
            "julia", "kotlin", "ledger", "nix", "ocaml", "ocaml_interface",
            "php", "ql", "query", "r", "rst", "ruby", "scss", "sparql",
            "supercollider", "svelte", "teal", "tsx", "typescript", "turtle",
            "verilog", "vue", "zig"
        },
        highlight = {enable = true, disable = {'vim'}},
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner"
                }
            }
        }
    }
end

function config.neoformat()
    vim.g.neoformat_basic_format_align = 1
    vim.g.neoformat_basic_format_retab = 1
    vim.g.neoformat_basic_format_trim = 1
    vim.g.neoformat_try_formatprg = 1
    vim.g.neoformat_only_msg_on_error = 1
    vim.g.neoformat_run_all_formatters = 1
    vim.g.shfmt_opt = "-ci"

    vim.g.neoformat_enabled_c = 'clangformat'
    vim.g.neoformat_enabled_cpp = 'clangformat'
    vim.g.neoformat_enabled_cmake = 'cmake_format'
    vim.g.neoformat_enabled_go = {'gofmt', 'goimports'}
    vim.g.neoformat_enabled_python = {'autopep8', 'yapf'}
    vim.g.neoformat_enabled_rust = 'rustfmt'
    vim.g.neoformat_enabled_shell = 'shfmt'
    vim.g.neoformat_enabled_markdown = 'prettier'
    vim.g.neoformat_enabled_html = 'prettier'
end

function config.autopairs()
    require('nvim-autopairs').setup({
        disable_filetype = {"TelescopePrompt"},
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
        enable_moveright = true,
        -- add bracket pairs after quote
        enable_afterquote = true,
        -- check bracket in same line
        enable_check_bracket_line = true,
        check_ts = true
    })

    require("nvim-autopairs.completion.compe").setup({
        map_cr = true,
        map_complete = true
    })
end

function config.autotag()
    require('nvim-ts-autotag').setup({
        filetypes = {
            "html", "xml", "javascript", "typescriptreact", "javascriptreact",
            "vue"
        }
    })
end

function config.accelerated_jk()
    if packer_plugins['accelerated-jk'] and
        not packer_plugins['accelerated-jk'].loaded then
        vim.cmd [[packadd accelerated-jk]]
    end
    vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)',
                            {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)',
                            {noremap = true, silent = true})
end

function config.sneak()
    if packer_plugins['vim-sneak'] and not packer_plugins['vim-sneak'].loaded then
        vim.cmd [[packadd vim-sneak]]
    end
    vim.api.nvim_set_keymap('n', 'f', '<Plug>Sneak_s',
                            {noremap = true, silent = false})
    vim.api.nvim_set_keymap('n', 'F', '<Plug>Sneak_S',
                            {noremap = true, silent = false})
    vim.api.nvim_set_keymap('n', 't', '<Plug>Sneak_t',
                            {noremap = true, silent = false})
    vim.api.nvim_set_keymap('n', 'T', '<Plug>Sneak_T',
                            {noremap = true, silent = false})
end

function config.split_term()
    if packer_plugins['split-term'] and not packer_plugins['split-term'].loaded then
        vim.cmd [[packadd split-term]]
    end
    vim.api.nvim_set_keymap('n', '<F5>', 'Term',
                            {noremap = true, silent = false})
    vim.api.nvim_set_keymap('n', '<C-w>t', 'Term',
                            {noremap = true, silent = false})
    vim.api.nvim_set_keymap('n', '<C-w>T', 'VTerm',
                            {noremap = true, silent = false})
end

function config.nvim_colorizer()
    require('colorizer').setup {
        css = {rgb_fn = true},
        scss = {rgb_fn = true},
        sass = {rgb_fn = true},
        stylus = {rgb_fn = true},
        vim = {names = true},
        tmux = {names = false},
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        html = {mode = 'foreground'}
    }
end

return config
