local config = {}

function config.telescope()
    local home = os.getenv("HOME")

    if not packer_plugins['plenary.nvim'].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end

    if not packer_plugins['popup.nvim'].loaded then
        vim.cmd [[packadd popup.nvim]]
    end

    if not packer_plugins['telescope-fzy-native.nvim'].loaded then
        vim.cmd [[packadd telescope-fzy-native.nvim]]
    end

    if not packer_plugins['telescope-project.nvim'].loaded then
        vim.cmd [[packadd telescope-project.nvim]]
    end

    if not packer_plugins['sql.nvim'].loaded then
        vim.cmd [[packadd sql.nvim]]
    end

    if not packer_plugins['telescope-frecency.nvim'].loaded then
        vim.cmd [[packadd telescope-frecency.nvim]]
    end

    if not packer_plugins['nvim-neoclip.lua'].loaded then
        vim.cmd [[packadd nvim-neoclip.lua]]
    end

    require('telescope').setup {
        defaults = {
            prompt_prefix = '🔭 ',
            selection_caret = " ",
            layout_config = {
                horizontal = {prompt_position = "bottom", results_width = 0.6},
                vertical = {mirror = false}
            },
            file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep
                .new,
            qflist_previewer = require'telescope.previewers'.vim_buffer_qflist
                .new,
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = {},
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = {"absolute"},
            winblend = 0,
            border = {},
            borderchars = {
                "─", "│", "─", "│", "╭", "╮", "╯", "╰"
            },
            color_devicons = true,
            use_less = true,
            set_env = {["COLORTERM"] = "truecolor"}
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true
            },
            frecency = {
                show_scores = true,
                show_unindexed = true,
                ignore_patterns = {"*.git/*", "*/tmp/*"},
                workspaces = {
                    ["conf"] = home .. "/.config",
                    ["data"] = home .. "/.local/share",
                    ["nvim"] = home .. "/.config/nvim",
                    ["code"] = home .. "/code",
                    ["c"] = home .. "/code/c",
                    ["cpp"] = home .. "/code/cpp",
                    ["go"] = home .. "/go/src",
                    ["rust"] = home .. "/code/rs"
                }
            },
            neoclip = {
                history = 1000,
                filter = nil,
                preview = true,
                default_register = '"',
                content_spec_column = false,
                on_paste = {
                    set_reg = false,
                },
                keys = {
                    i = {
                    select = '<cr>',
                    paste = '<c-p>',
                    paste_behind = '<c-k>',
                    },
                    n = {
                    select = '<cr>',
                    paste = 'p',
                    paste_behind = 'P',
                    },
                },
            }
        }
    }
    require('telescope').load_extension('fzy_native')
    require('telescope').load_extension('project')
    require('telescope').load_extension('frecency')
    require('telescope').load_extension('neoclip')
end

function config.trouble()
    require("trouble").setup {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        action_keys = { -- key mappings for actions in the trouble list
            -- map to {} to remove a mapping, for example:
            -- close = {},
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
            open_split = {"<c-x>"}, -- open buffer in new split
            open_vsplit = {"<c-v>"}, -- open buffer in new vsplit
            open_tab = {"<c-t>"}, -- open buffer in new tab
            jump_close = {"o"}, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = {"zM", "zm"}, -- close all folds
            open_folds = {"zR", "zr"}, -- open all folds
            toggle_fold = {"zA", "za"}, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
        use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    }
end

function config.sniprun()
    require'sniprun'.setup({
        selected_interpreters = {}, -- " use those instead of the default for the current filetype
        repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
        repl_disable = {}, -- " disable REPL-like behavior for the given interpreters

        interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>

        -- " you can combo different display modes as desired
        display = {
            "Classic", -- "display results in the command-line  area
            "VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)

            "VirtualTextErr", -- "display error results as virtual text
            -- "TempFloatingWindow",      -- "display results in a floating window
            "LongTempFloatingWindow" -- "same as above, but only long results. To use with VirtualText__
            -- "Terminal"                 -- "display results in a vertical split
        },

        -- " miscellaneous compatibility/adjustement settings
        inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
        -- " to workaround sniprun not being able to display anything

        borders = 'shadow' -- " display borders around floating windows
        -- " possible values are 'none', 'single', 'double', or 'shadow'
    })
end

function config.wilder()
    vim.cmd [[
call wilder#setup({'modes': [':', '/', '?']})
    ]]
end

return config
