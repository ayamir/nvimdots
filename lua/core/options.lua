local global = require("core.global")

local function load_options()
	local options = {
		-- viewdir = global.cache_dir .. "/view/",
		autoread = true,
		autowrite = true,
		backspace = "indent,eol,start",
		backup = false,
		backupdir = global.cache_dir .. "/backup//,.",
		backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
		breakat = [[\ \	;:,!?@*-+/]],
		clipboard = "unnamedplus",
		cmdheight = 1, -- 0, 1, 2
		cmdwinheight = 5,
		complete = ".,w,b,k,kspell",
		completeopt = "fuzzy,menuone,noselect,popup",
		cursorcolumn = true,
		cursorline = true,
		diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience",
		directory = global.cache_dir .. "/swap//",
		display = "lastline",
		encoding = "utf-8",
		equalalways = false,
		errorbells = true,
		fileencodings = "ucs-bom,utf-8,default,big5,latin1",
		fileformats = "unix,mac,dos",
		foldlevelstart = 99,
		grepformat = "%f:%l:%c:%m",
		grepprg = "rg --hidden --vimgrep --smart-case --",
		helpheight = 12,
		hidden = true,
		history = 2000,
		ignorecase = true,
		inccommand = "nosplit",
		incsearch = true,
		infercase = true,
		jumpoptions = "stack,view",
		laststatus = 3,
		list = true,
		listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
		magic = true,
		mousescroll = "ver:3,hor:6",
		previewheight = 12,
		-- Do NOT adjust the following option (pumblend) if you're using transparent background
		pumblend = 0,
		pumheight = 15,
		redrawtime = 1500,
		ruler = true,
		scrolloff = 3,
		sessionoptions = "buffers,curdir,folds,help,tabpages,winpos,winsize",
		shada = "!,'500,<50,@100,s10,h",
		shiftround = true,
		shortmess = "aoOTIcF",
		showbreak = "↳  ",
		showcmd = false,
		showmode = false,
		showtabline = 2,
		sidescrolloff = 5,
		smartcase = true,
		smarttab = true,
		smoothscroll = true,
		spellfile = global.vim_path .. "/spell/en.utf-8.add",
		splitbelow = true,
		splitkeep = "screen",
		splitright = true,
		startofline = false,
		swapfile = true,
		switchbuf = "usetab,uselast",
		termguicolors = true,
		timeout = true,
		timeoutlen = 300,
		ttimeout = true,
		ttimeoutlen = 0,
		undodir = global.cache_dir .. "/undo//",
		-- Please do NOT set `updatetime` to above 500, otherwise most plugins may not function correctly
		updatetime = 200,
		viewoptions = "folds,cursor,curdir,slash,unix",
		virtualedit = "block",
		visualbell = true,
		whichwrap = "h,l,<,>,[,],~",
		wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
		wildignorecase = true,
		-- Do NOT adjust the following option (winblend) if you're using transparent background
		winblend = 0,
		winminwidth = 10,
		winwidth = 30,
		wrapscan = true,
		writebackup = true,
		-- bw local --
		autoindent = true,
		breakindentopt = "shift:2,min:20",
		concealcursor = "niv",
		conceallevel = 0,
		expandtab = true,
		foldenable = true,
		formatoptions = "1jcroql",
		linebreak = true,
		number = true,
		relativenumber = true,
		shiftwidth = 4,
		signcolumn = "yes",
		softtabstop = 4,
		synmaxcol = 2500,
		tabstop = 4,
		textwidth = 80,
		undofile = true,
		wrap = false,
	}

	local function isempty(s)
		return s == nil or s == ""
	end
	local function use_if_defined(val, fallback)
		return val ~= nil and val or fallback
	end

	-- Custom python provider
	local conda_prefix = vim.env.CONDA_PREFIX
	if not isempty(conda_prefix) then
		vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix .. "/bin/python")
		vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix .. "/bin/python")
	else
		vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
		vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
	end

	for name, value in pairs(require("modules.utils").extend_config(options, "user.options")) do
		vim.api.nvim_set_option_value(name, value, {})
	end
end

-- Newtrw liststyle: https://medium.com/usevim/the-netrw-style-options-3ebe91d42456
vim.g.netrw_liststyle = 3

load_options()
