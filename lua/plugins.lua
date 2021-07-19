local execute = vim.api.nvim_command
local fn = vim.fn

local packer_install_dir = fn.stdpath('data') ..
                               '/site/pack/packer/start/packer.nvim'

local plug_url_format = 'https://hub.fastgit.org/%s'

local packer_repo = string.format(plug_url_format, 'wbthomason/packer.nvim')
local install_cmd = string.format('10split |term git clone --depth=1 %s %s',
                                  packer_repo, packer_install_dir)

if fn.empty(fn.glob(packer_install_dir)) > 0 then
    vim.api.nvim_echo({{'Installing packer.nvim', 'Type'}}, true, {})
    execute(install_cmd)
    execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

-- the plugin install follows from here
-- ....

local ui = require('ui.config')
local tools = require('tools.config')
local editor = require('editor.config')
local completion = require('completion.config')
local lang = require('lang.config')

require('packer').startup(function()
    -- UI
    use {'sonph/onehalf', rtp = 'vim/'}
    use 'arcticicestudio/nord-vim'
    use {
        'glepnir/galaxyline.nvim',
        config = ui.galaxyline,
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {'glepnir/dashboard-nvim', config = ui.dashboard}
    use {
        'kyazdani42/nvim-tree.lua',
        opt = true,
        cmd = {'NvimTreeToggle', 'NvimTreeOpen'},
        config = ui.nvim_tree,
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
        'lewis6991/gitsigns.nvim',
        opt = true,
        event = {'BufRead', 'BufNewFile'},
        config = ui.gitsigns,
        requires = {'nvim-lua/plenary.nvim', opt = true}
    }
    use {
        'akinsho/nvim-bufferline.lua',
        config = ui.nvim_bufferline,
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
        'folke/zen-mode.nvim',
        opt = true,
        cmd = 'ZenMode',
        config = ui.zen_mode
    }
    use {
        'folke/twilight.nvim',
        opt = true,
        cmd = {'Twilight', 'TwilightEnable'},
        config = ui.twilight
    }
    -- Tools
    use {
        'nvim-telescope/telescope.nvim',
        opt = true,
        cmd = 'Telescope',
        config = tools.telescope,
        requires = {
            {'nvim-lua/popup.nvim', opt = true},
            {'nvim-lua/plenary.nvim', opt = true},
            {'nvim-telescope/telescope-fzy-native.nvim', opt = true},
            {'nvim-telescope/telescope-project.nvim', opt = true}, {
                "nvim-telescope/telescope-frecency.nvim",
                opt = true,
                requires = {'tami5/sql.nvim', opt = true}
            }
        }
    }
    -- Editor
    use {'junegunn/vim-easy-align', opt = true, cmd = 'EasyAlign'}
    use {
        'itchyny/vim-cursorword',
        opt = true,
        event = {'BufReadPre', 'BufNewFile'},
        config = editor.vim_cursorwod
    }
    use {'tpope/vim-commentary', opt = true, cmd = 'Commentary'}
    use {
        'simrat39/symbols-outline.nvim',
        opt = true,
        cmd = {'SymbolsOutline', 'SymbolsOulineOpen'},
        config = editor.symbols_outline
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        opt = true,
        run = ':TSUpdate',
        event = 'BufRead',
        after = 'telescope.nvim',
        config = editor.nvim_treesitter
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        opt = true,
        after = 'nvim-treesitter'
    }
    use {'p00f/nvim-ts-rainbow', opt = true}
    use {
        'sbdchd/neoformat',
        opt = true,
        cmd = 'Neoformat',
        config = editor.neoformat
    }
    use {
        'windwp/nvim-autopairs',
        opt = true,
        event = 'InsertEnter',
        config = editor.autopairs
    }
    use {
        'windwp/nvim-ts-autotag',
        opt = true,
        ft = {'html', 'xml'},
        config = editor.autotag
    }
    use {'rhysd/accelerated-jk', opt = true, config = editor.accelerated_jk}
    use {
        'justinmk/vim-sneak',
        opt = true,
        cmd = {
            '<Plug>Sneak_s', '<Plug>Sneak_S', '<Plug>Sneak_t', '<Plug>Sneak_T'
        },
        config = editor.sneak
    }
    use {'junegunn/vim-slash', opt = true}
    use {
        'vimlab/split-term.vim',
        opt = true,
        cmd = {'Term', 'VTerm'},
        config = editor.split_term
    }
    use {'thinca/vim-quickrun', opt = true, cmd = {'QuickRun', 'Q'}}
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'html', 'css', 'sass', 'vim', 'typescript', 'typescriptreact'},
        config = editor.nvim_colorizer
    }
    -- Completion
    use {
        'neovim/nvim-lspconfig',
        opt = true,
        event = 'BufReadPre',
        config = completion.lspconfig,
        requires = {'nvim-lua/lsp_extensions.nvim'}
    }
    use {
        'kabouzeid/nvim-lspinstall',
        opt = true,
        cmd = {'LspInstall', 'LspUninstall'}
    }
    use {
        'onsails/lspkind-nvim',
        opt = true,
        event = 'BufRead',
        config = completion.lspkind
    }
    use {'glepnir/lspsaga.nvim', opt = true, cmd = 'Lspsaga'}
    use {
        'hrsh7th/nvim-compe',
        opt = true,
        after = 'nvim-lspconfig',
        config = completion.compe,
        requires = {
            {'ray-x/lsp_signature.nvim', opt = true},
            {'tzachar/compe-tabnine', opt = true, run = './install.sh'},
            {'hrsh7th/vim-vsnip', opt = true},
            {'hrsh7th/vim-vsnip-integ', opt = true},
            {'rafamadriz/friendly-snippets', opt = true}, {
                'SirVer/ultisnips',
                opt = true,
                config = completion.ultisnips,
                requires = {'honza/vim-snippets', opt = true}
            }
        }
    }
    -- Lang
    use {
        'fatih/vim-go',
        opt = true,
        ft = 'go',
        run = ':GoInstallBinaries',
        config = lang.go
    }
    use {'rust-lang/rust.vim', opt = true, ft = "rust", config = lang.rust}
    use {
        'kristijanhusak/orgmode.nvim',
        opt = true,
        ft = "org",
        config = lang.org
    }
    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app && yarn install',
        cmd = {'MarkdownPreview', 'MarkdownPreviewToggle'},
        config = lang.markdown
    }
end, {config = {max_jobs = 16, git = {default_url_format = plug_url_format}}})
