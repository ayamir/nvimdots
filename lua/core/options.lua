local global = require("core.global")

local function load_options()
	local global_local = {
		-- backupdir = global.cache_dir .. "backup/",
		-- directory = global.cache_dir .. "swap/",
		-- pumblend = 10,
		-- spellfile = global.cache_dir .. "spell/en.uft-8.add",
		-- viewdir = global.cache_dir .. "view/",
		-- winblend = 10,
		autoindent = true,
		autoread = true,
		autowrite = true,
		backspace = "indent,eol,start",
		backup = false,
		backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
		breakat = [[\ \	;:,!?]],
		breakindentopt = "shift:2,min:20",
		clipboard = "unnamedplus",
		cmdheight = 2, -- 0, 1, 2
		cmdwinheight = 5,
		complete = ".,w,b,k",
		completeopt = "menuone,noselect",
		concealcursor = "niv",
		conceallevel = 0,
		cursorcolumn = true,
		cursorline = true,
		diffopt = "filler,iwhite,internal,algorithm:patience",
		display = "lastline",
		encoding = "utf-8",
		equalalways = false,
		errorbells = true,
		expandtab = true,
		fileformats = "unix,mac,dos",
		foldenable = true,
		foldlevelstart = 99,
		formatoptions = "1jcroql",
		grepformat = "%f:%l:%c:%m",
		grepprg = "rg --hidden --vimgrep --smart-case --",
		helpheight = 12,
		hidden = true,
		history = 2000,
		ignorecase = true,
		inccommand = "nosplit",
		incsearch = true,
		infercase = true,
		jumpoptions = "stack",
		laststatus = 2,
		linebreak = true,
		list = true,
		listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
		magic = true,
		mousescroll = "ver:3,hor:6",
		number = true,
		previewheight = 12,
		pumheight = 15,
		redrawtime = 1500,
		relativenumber = true,
		ruler = true,
		scrolloff = 2,
		sessionoptions = "curdir,help,tabpages,winsize",
		shada = "!,'300,<50,@100,s10,h",
		shiftround = true,
		shiftwidth = 4,
		shortmess = "aoOTIcF",
		showbreak = "↳  ",
		showcmd = false,
		showmode = false,
		showtabline = 2,
		sidescrolloff = 5,
		signcolumn = "yes",
		smartcase = true,
		smarttab = true,
		softtabstop = 4,
		splitbelow = true,
		splitright = true,
		startofline = false,
		swapfile = false,
		switchbuf = "usetab,uselast",
		synmaxcol = 2500,
		tabstop = 4,
		termguicolors = true,
		timeout = true,
		-- You will feel delay when you input <Space> at lazygit interface if you set it a positive value like 300(ms).
		timeoutlen = 0,
		ttimeout = true,
		ttimeoutlen = 0,
		undodir = global.cache_dir .. "undo/",
		undofile = true,
		-- Please do NOT set `updatetime` to above 500, otherwise most plugins may not work correctly
		updatetime = 200,
		viewoptions = "folds,cursor,curdir,slash,unix",
		virtualedit = "block",
		visualbell = true,
		whichwrap = "h,l,<,>,[,],~",
		wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
		wildignorecase = true,
		winminwidth = 10,
		winwidth = 30,
		wrap = false,
		wrapscan = true,
		writebackup = false,
	}
	local function isempty(s)
		return s == nil or s == ""
	end

	-- custom python provider
	local conda_prefix = os.getenv("CONDA_PREFIX")
	if not isempty(conda_prefix) then
		vim.g.python_host_prog = conda_prefix .. "/bin/python"
		vim.g.python3_host_prog = conda_prefix .. "/bin/python"
	elseif global.is_mac then
		vim.g.python_host_prog = "/usr/bin/python"
		vim.g.python3_host_prog = "/usr/local/bin/python3"
	else
		vim.g.python_host_prog = "/usr/bin/python"
		vim.g.python3_host_prog = "/usr/bin/python3"
	end

	for name, value in pairs(global_local) do
		vim.o[name] = value
	end

	-- Fix sqlite3 missing-lib issue on Windows
	if global.is_windows then
		-- Download the DLLs form https://www.sqlite.org/download.html
		vim.g.sqlite_clib_path = global.home .. "/Documents/sqlite-dll-win64-x64-3400100/sqlite3.dll"
	end
end

load_options()
