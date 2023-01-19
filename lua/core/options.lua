local global = require("core.global")

local function load_options()
	local global_local = {
		termguicolors = true,
		errorbells = true,
		visualbell = true,
		hidden = true,
		fileformats = "unix,mac,dos",
		magic = true,
		virtualedit = "block",
		encoding = "utf-8",
		viewoptions = "folds,cursor,curdir,slash,unix",
		sessionoptions = "curdir,help,tabpages,winsize",
		clipboard = "unnamedplus",
		wildignorecase = true,
		wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
		backup = false,
		writebackup = false,
		swapfile = false,
		undodir = global.cache_dir .. "undo/",
		-- directory = global.cache_dir .. "swap/",
		-- backupdir = global.cache_dir .. "backup/",
		-- viewdir = global.cache_dir .. "view/",
		-- spellfile = global.cache_dir .. "spell/en.uft-8.add",
		history = 2000,
		shada = "!,'300,<50,@100,s10,h",
		backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
		smarttab = true,
		shiftround = true,
		timeout = true,
		ttimeout = true,
		-- You will feel delay when you input <Space> at lazygit interface if you set it a positive value like 300(ms).
		timeoutlen = 0,
		ttimeoutlen = 0,
		updatetime = 100,
		redrawtime = 1500,
		ignorecase = true,
		smartcase = true,
		infercase = true,
		incsearch = true,
		wrapscan = true,
		complete = ".,w,b,k",
		inccommand = "nosplit",
		grepformat = "%f:%l:%c:%m",
		grepprg = "rg --hidden --vimgrep --smart-case --",
		breakat = [[\ \	;:,!?]],
		startofline = false,
		whichwrap = "h,l,<,>,[,],~",
		splitbelow = true,
		splitright = true,
		switchbuf = "usetab,uselast",
		backspace = "indent,eol,start",
		diffopt = "filler,iwhite,internal,algorithm:patience",
		completeopt = "menuone,noselect",
		jumpoptions = "stack",
		showmode = false,
		shortmess = "aoOTIcF",
		scrolloff = 2,
		sidescrolloff = 5,
		mousescroll = "ver:3,hor:6",
		foldlevelstart = 99,
		ruler = true,
		cursorline = true,
		cursorcolumn = true,
		list = true,
		showtabline = 2,
		winwidth = 30,
		winminwidth = 10,
		pumheight = 15,
		helpheight = 12,
		previewheight = 12,
		showcmd = false,
		cmdheight = 2, -- 0, 1, 2
		cmdwinheight = 5,
		equalalways = false,
		laststatus = 2,
		display = "lastline",
		showbreak = "↳  ",
		listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
		-- pumblend = 10,
		-- winblend = 10,
		autoread = true,
		autowrite = true,

		undofile = true,
		synmaxcol = 2500,
		formatoptions = "1jcroql",
		expandtab = true,
		autoindent = true,
		tabstop = 4,
		shiftwidth = 4,
		softtabstop = 4,
		breakindentopt = "shift:2,min:20",
		wrap = false,
		linebreak = true,
		number = true,
		relativenumber = true,
		foldenable = true,
		signcolumn = "yes",
		conceallevel = 0,
		concealcursor = "niv",
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
end

load_options()
