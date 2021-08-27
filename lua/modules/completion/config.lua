local config = {}

function config.nvim_lsp() require('modules.completion.lspconfig') end

function config.lspkind()
    require('lspkind').init({
        -- enables text annotations
        with_text = true,
        -- can be either 'default' or
        -- 'codicons' for codicon preset (requires vscode-codicons font installed)
        -- default: 'default'
        preset = 'codicons',
        -- override preset symbols
        symbol_map = {
            Text = '',
            Method = 'ƒ',
            Function = '',
            Constructor = '',
            Variable = '',
            Class = '',
            Interface = 'ﰮ',
            Module = '',
            Property = '',
            Unit = '',
            Value = '',
            Enum = '',
            Keyword = '',
            Snippet = '﬌',
            Color = '',
            File = '',
            Folder = '',
            EnumMember = '',
            Constant = '',
            Struct = ''
        }
    })
end

function config.saga()
    vim.api.nvim_command("autocmd CursorHold * Lspsaga show_line_diagnostics")
end

function config.cmp()
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    local cmp = require('cmp')
    cmp.setup {
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end
        },
        -- You can set mappings if you want
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if vim.fn.pumvisible() == 1 then
                    if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or
                        vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        return vim.fn.feedkeys(t(
                                                   "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"))
                    end

                    vim.fn.feedkeys(t("<C-n>"), "n")
                elseif check_back_space() then
                    vim.fn.feedkeys(t("<tab>"), "n")
                else
                    fallback()
                end
            end, {"i", "s"})
        },

        -- You should specify your *installed* sources.
        sources = {
            {name = 'buffer'}, {name = 'path'}, {name = 'tags'},
            {name = 'ultisnips'}, {name = 'nvim_lua'}, {name = 'cmp_tabnine'},
            {name = 'spell'}, {name = 'tmux'}
        }
    }
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

    require("nvim-autopairs.completion.cmp").setup({
        map_cr = true, --  map <CR> on insert mode
        map_complete = true, -- it will auto insert `(` after select function or method item
        auto_select = true -- automatically select the first item
    })
end

return config
