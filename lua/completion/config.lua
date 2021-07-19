local config = {}

function config.lspconfig() require('completion.lspconfig') end

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
            Enum = '了',
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

function config.compe()
    require('compe').setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        resolve_timeout = 800,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
            path = true,
            buffer = true,
            calc = true,
            spell = true,
            tags = true,

            orgmode = true,
            snippetSupport = true,
            nvim_lsp = true,
            nvim_lua = true,
            treesitter = true,
            vsnip = true,
            ultisnips = true,
            tabnine = {
                max_line = 1000,
                max_num_results = 6,
                priority = 5000,
                show_prediction_strength = true,
                sort = false,
                ignore_pattern = '[(]'
            }
        }
    }

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
        elseif vim.fn.call("vsnip#available", {1}) == 1 then
            return t "<Plug>(vsnip-expand-or-jump)"
        elseif check_back_space() then
            return t "<Tab>"
        else
            return vim.fn['compe#complete']()
        end
    end

    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
        elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
            return t "<Plug>(vsnip-jump-prev)"
        else
            return t "<S-Tab>"
        end
    end

    local remap = vim.api.nvim_set_keymap

    remap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    remap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    remap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    remap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
end

function config.ultisnips()
    vim.g.UltiSnipsExpandTrigger = "<NUL>"
    vim.g.UltiSnipsJumpForwardTrigger = "<C-l>"
    vim.g.UltiSnipsJumpBackwardTrigger = "<C-h>"
    vim.g.UltiSnipsEditSplit = "vertical"
end

return config
