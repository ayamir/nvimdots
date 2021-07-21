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

function config.autotag()
    require('nvim-ts-autotag').setup({
        filetypes = {
            "html", "xml", "javascript", "typescriptreact", "javascriptreact",
            "vue"
        }
    })
end

function config.split_term()
    if packer_plugins['split-term'] and not packer_plugins['split-term'].loaded then
        vim.cmd [[packadd split-term]]
    end
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

function config.easymotion()
    vim.g.EasyMotion_do_mapping = 0
    vim.g.EasyMotion_smartcase = 1
    vim.g.EasyMotion_use_smartsign_us = 1
end

return config
