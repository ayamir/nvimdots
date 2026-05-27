local tool = {}
local settings = require("core.settings")

tool["tpope/vim-fugitive"] = {
	lazy = true,
	cmd = { "Git", "G" },
}
-- This is specifically for fcitx5 users who code in languages other than English
-- tool["pysan3/fcitx5.nvim"] = {
-- 	lazy = true,
-- 	event = "BufReadPost",
-- 	cond = vim.fn.executable("fcitx5-remote") == 1,
-- 	config = require("tool.fcitx5"),
-- }
tool["Bekaboo/dropbar.nvim"] = {
	lazy = false,
	config = require("tool.dropbar"),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
}
tool["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = require("tool.nvim-tree"),
}
tool["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tool.smartyank"),
}
tool["michaelb/sniprun"] = {
	lazy = true,
	-- If you see an error about a missing SnipRun executable,
	-- run `bash ./install.sh` inside `~/.local/share/nvim/site/lazy/sniprun/`.
	build = "bash ./install.sh",
	cmd = { "SnipRun", "SnipReset", "SnipInfo" },
	config = require("tool.sniprun"),
}
tool["akinsho/toggleterm.nvim"] = {
	lazy = true,
	cmd = {
		"ToggleTerm",
		"ToggleTermSetName",
		"ToggleTermToggleAll",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualSelection",
	},
	config = require("tool.toggleterm"),
}
tool["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("tool.trouble"),
}
tool["folke/which-key.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("tool.which-key"),
}
tool["gelguy/wilder.nvim"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = require("tool.wilder"),
	dependencies = "romgrk/fzy-lua-native",
}
if settings.use_chat then
	tool["olimorris/codecompanion.nvim"] = {
		lazy = true,
		tag = "v17.33.0",
		-- event = "VeryLazy",
	-- 不要使用 event = "VeryLazy"，改为在需要时加载，或者延迟加载
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		keys = {
		  { "<leader>a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" } },
		  { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" } },
		},
		config = require("tool.codecompanion"),
		dependencies = {
			{
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"ravitemer/codecompanion-history.nvim" },
		},
	}
end
-- Needs `fzf` installed and in $PATH
tool["ibhagwan/fzf-lua"] = {
	lazy = true,
	cond = (settings.search_backend == "fzf"),
	cmd = "FzfLua",
	config = require("tool.fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
}

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
tool["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("tool.telescope"),
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "debugloop/telescope-undo.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{ "fcying/telescope-ctags-outline.nvim"},
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{
			"ayamir/search.nvim",
			config = require("tool.search"),
		},
		{
			"DrKJeff16/project.nvim",
			event = { "CursorHold", "CursorHoldI" },
			config = require("tool.project"),
		},
		{
			"aaronhallaert/advanced-git-search.nvim",
			cmd = { "AdvancedGitSearch" },
			dependencies = {
				"tpope/vim-rhubarb",
				"tpope/vim-fugitive",
				"sindrets/diffview.nvim",
			},
		},
	},
}

----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
tool["mfussenegger/nvim-dap"] = {
	lazy = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	config = require("tool.dap"),
	dependencies = {
		{ "jay-babu/mason-nvim-dap.nvim" },
		{
			"rcarriga/nvim-dap-ui",
			dependencies = "nvim-neotest/nvim-nio",
			config = require("tool.dap.dapui"),
		},
	},
}


tool["Yggdroot/LeaderF"] = {
	lazy = false,
	run = ':LeaderfInstallCExtension',
}

tool["christoomey/vim-tmux-navigator"] = {
	lazy = false,
}

tool["tmux-plugins/vim-tmux"] = {
	lazy = false,
}

tool["skywind3000/asyncrun.vim"] = {
	lazy = false,
}

tool["junegunn/fzf"] = {
	lazy = false,
	run = function()
        -- 使用 fzf-nvim 包中的安装函数来安装 fzf 二进制文件
        vim.fn['fzf#install']()
        end
}

tool["stevearc/aerial.nvim"] = {
	lazy = false,
  opts = {},
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
}

tool["inkarkat/vim-mark"] = {
	lazy = false,
	dependencies = { "inkarkat/vim-ingo-library" },
}

tool["c0r73x/neotags.lua"] = {
	lazy = false,
	config = function()
--	插件加载后调用 toggle 函数
		require('neotags').toggle()
	end,
}

tool["cshuaimin/ssr.nvim"] = {
	lazy = false,
	  module = "ssr",
  -- Calling setup is optional.
  config = function()
    require("ssr").setup {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      adjust_window = true,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    }
  end
}

tool["jeffkreeftmeijer/vim-numbertoggle"] = {
	lazy = false,
}

tool["justinmk/vim-sneak"] = {
	lazy = false,
}

tool["gbprod/yanky.nvim"] = {
	lazy = false,
}

tool["szw/vim-maximizer"] = {
	lazy = false,
}
tool['Wansmer/symbol-usage.nvim'] = {
	lazy = false,
	event = 'BufReadPre', -- 在LspAttach之前运行，如果使用的是nvim 0.9。对于0.10，使用'LspAttach'
	config = function()
		require('symbol-usage').setup()
	end
}

tool["linrongbin16/fzfx.nvim"] = {
	dependencies = { "nvim-tree/nvim-web-devicons", 'junegunn/fzf' },

		    -- specify version to avoid break changes
		    -- version = 'v5.*',

		    config = function()
			      require("fzfx").setup()
		    end,

}

-- Lua
tool['abecodes/tabout.nvim'] = {
    lazy = false,
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>', -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' }
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {} -- tabout will ignore these filetypes
      }
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp"
    },
    opt = true,  -- Set this to true if the plugin is optional
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
}

--tool["smoka7/multicursors.nvim"] = {
--    event = "VeryLazy",
--    dependencies = {
--        'nvimtools/hydra.nvim',
--    },
--	lazy = false,
--    opts = {},
--    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
--    keys = {
--            {
--                mode = { 'v', 'n' },
--                '<C-m>',
--                '<cmd>MCstart<cr>',
--                desc = 'Create a selection for selected text or word under the cursor',
--            },
--        },
--}

tool["chrisgrieser/nvim-spider"] = {
	lazy = false,
	keys = {
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
		},

		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
		},

	},
}
tool["MeanderingProgrammer/render-markdown.nvim"] = {
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}

tool["yousefhadder/markdown-plus.nvim"] = {
  ft = {"markdown"},
  config = function()
        require("markdown-plus").setup({
            -- 如果插件支持，可以在此禁用自动编号功能
            list = {
                -- enable_renumber = true, -- 或者设为 false 彻底关闭此功能
            }
        })
    end,
  opts = {},
}
return tool
