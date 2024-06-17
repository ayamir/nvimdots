-- Now use `<A-o>` or `<A-1>` to back to the `dotstutor`.
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		-- Prepend an underscore to avoid name clashes
		vim.api.nvim_command("augroup _" .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.iter({ "autocmd", def }):flatten(math.huge):totable(), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

-- Hold off on configuring anything related to the LSP until LspAttach
local mapping = require("keymap.completion")
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymapLoader", { clear = true }),
	callback = function(event)
		if not _G._debugging then
			-- LSP Keymaps
			mapping.lsp(event.buf)

			-- LSP Inlay Hints
			local inlayhints_enabled = require("core.settings").lsp_inlayhints
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.inlayHintProvider ~= nil then
				vim.lsp.inlay_hint.enable(inlayhints_enabled == true, { bufnr = event.buf })
			end
		end
	end,
})

-- auto close NvimTree
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
	pattern = "NvimTree_*",
	callback = function()
		local layout = vim.api.nvim_call_function("winlayout", {})
		if
			layout[1] == "leaf"
			and vim.bo[vim.api.nvim_win_get_buf(layout[2])].filetype == "NvimTree"
			and layout[3] == nil
		then
			vim.api.nvim_command([[confirm quit]])
		end
	end,
})

-- auto close some filetype with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"nofile",
		"lspinfo",
		"terminal",
		"prompt",
		"toggleterm",
		"copilot",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<Cmd>close<CR>", { silent = true })
	end,
})

function autocmd.load_autocmds()
	local definitions = {
		lazy = {},
		bufs = {
			-- Reload vim config automatically
			{
				"BufWritePost",
				[[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]],
			},
			-- Reload Vim script automatically if setlocal autoread
			{
				"BufWritePost,FileWritePost",
				"*.vim",
				[[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
			},
			{ "BufWritePre", "/tmp/*", "setlocal noundofile" },
			{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
			{ "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
			{ "BufWritePre", "*.tmp", "setlocal noundofile" },
			{ "BufWritePre", "*.bak", "setlocal noundofile" },
			-- auto place to last edit
			{
				"BufReadPost",
				"*",
				[[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]],
			},
			-- Auto toggle fcitx5
			-- {"InsertLeave", "* :silent", "!fcitx5-remote -c"},
			-- {"BufCreate", "*", ":silent !fcitx5-remote -c"},
			-- {"BufEnter", "*", ":silent !fcitx5-remote -c "},
			-- {"BufLeave", "*", ":silent !fcitx5-remote -c "}
		},
		wins = {
			-- Highlight current line only on focused window
			{
				"WinEnter,BufEnter,InsertLeave",
				"*",
				[[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
			},
			{
				"WinLeave,BufLeave,InsertEnter",
				"*",
				[[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
			},
			-- Attempt to write shada when leaving nvim
			{
				"VimLeave",
				"*",
				[[if has('nvim') | wshada | else | wviminfo! | endif]],
			},
			-- Check if file changed when its window is focus, more eager than 'autoread'
			{ "FocusGained", "* checktime" },
			-- Equalize window dimensions when resizing vim window
			{ "VimResized", "*", [[tabdo wincmd =]] },
		},
		ft = {
			{ "FileType", "*", "setlocal formatoptions-=cro" },
			{ "FileType", "alpha", "setlocal showtabline=0" },
			{ "FileType", "markdown", "setlocal wrap" },
			{ "FileType", "dap-repl", "lua require('dap.ext.autocompl').attach()" },
			{
				"FileType",
				"c,cpp",
				"nnoremap <leader>h :ClangdSwitchSourceHeaderVSplit<CR>",
			},
		},
		yank = {
			{
				"TextYankPost",
				"*",
				[[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]],
			},
		},
	}
	autocmd.nvim_create_augroups(require("modules.utils").extend_config(definitions, "user.event"))
end

autocmd.load_autocmds()
