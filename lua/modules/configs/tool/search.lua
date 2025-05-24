return function()
	local search_backend = require("core.settings").search_backend
	local builtin = require("telescope.builtin")
	local extensions = require("telescope").extensions
	local vim_path = require("core.global").vim_path
	local prompt_position = require("telescope.config").values.layout_config.horizontal.prompt_position
	local fzf_opts = { fzf_opts = { ["--layout"] = prompt_position == "top" and "reverse" or "default" } }
	local files = function()
		if search_backend == "fzf" then
			return function()
				local opts = {}
				local fzf = require("fzf-lua")
				opts = vim.tbl_deep_extend("force", opts, fzf_opts)
				if vim.fn.getcwd() == vim_path then
					fzf.files(vim.tbl_deep_extend("force", opts, { no_ignore = true }))
				elseif vim.fn.isdirectory(".git") == 1 then
					fzf.git_files(opts)
				else
					fzf.files(opts)
				end
			end
		else
			return function(opts)
				opts = opts or {}
				if vim.fn.getcwd() == vim_path then
					builtin.find_files(vim.tbl_deep_extend("force", opts, { no_ignore = true }))
				elseif vim.fn.isdirectory(".git") == 1 then
					builtin.git_files(opts)
				else
					builtin.find_files(opts)
				end
			end
		end
	end

	local old_files = function()
		if search_backend == "fzf" then
			return function()
				local opts = {}
				local fzf = require("fzf-lua")
				opts = vim.tbl_deep_extend("force", opts, fzf_opts)
				fzf.oldfiles(opts)
			end
		else
			return function(opts)
				opts = opts or {}
				builtin.oldfiles(opts)
			end
		end
	end

	local word_in_project = function()
		if search_backend == "fzf" then
			return function()
				local opts = {}
				local fzf = require("fzf-lua")
				opts = vim.tbl_deep_extend("force", opts, fzf_opts)
				if vim.fn.getcwd() == vim_path then
					opts = vim.tbl_deep_extend("force", opts, { no_ignore = true })
				end
				fzf.live_grep(opts)
			end
		else
			return function(opts)
				opts = opts or {}
				if vim.fn.getcwd() == vim_path then
					opts["additional_args"] = { "--no-ignore" }
				end
				extensions.live_grep_args.live_grep_args(opts)
			end
		end
	end

	local word_under_cursor = function()
		if search_backend == "fzf" then
			return function()
				local opts = {}
				local fzf = require("fzf-lua")
				opts = vim.tbl_deep_extend("force", opts, fzf_opts)
				if vim.fn.getcwd() == vim_path then
					opts = vim.tbl_deep_extend("force", opts, { no_ignore = true })
				end
				fzf.grep_cword(opts)
			end
		else
			return function(opts)
				opts = opts or {}
				if vim.fn.getcwd() == vim_path then
					opts["additional_args"] = { "--no-ignore" }
				end
				builtin.grep_string(opts)
			end
		end
	end

	require("modules.utils").load_plugin("search", {
		prompt_position = prompt_position,
		collections = {
			-- Search using filenames
			file = {
				initial_tab = 1,
				tabs = {
					{
						name = "Files",
						tele_func = files(),
					},
					{
						name = "Frecency",
						tele_func = function()
							extensions.frecency.frecency()
						end,
					},
					{
						name = "Oldfiles",
						tele_func = old_files(),
					},
					{
						name = "Buffers",
						tele_func = function()
							builtin.buffers()
						end,
					},
				},
			},
			-- Search using patterns
			pattern = {
				initial_tab = 1,
				tabs = {
					{
						name = "Word in project",
						tele_func = word_in_project(),
					},
					{
						name = "Word under cursor",
						tele_func = word_under_cursor(),
					},
				},
			},
			-- Search Git objects (branches, commits)
			git = {
				initial_tab = 1,
				tabs = {
					{
						name = "Branches",
						tele_func = function()
							builtin.git_branches()
						end,
					},
					{
						name = "Commits",
						tele_func = function()
							builtin.git_commits()
						end,
					},
					{
						name = "Commit content",
						tele_func = function()
							extensions.advanced_git_search.search_log_content()
						end,
					},
					{
						name = "Diff current file with commit",
						tele_func = function()
							extensions.advanced_git_search.diff_commit_file()
						end,
					},
				},
			},
			-- Retrieve dossiers
			dossier = {
				initial_tab = 1,
				tabs = {
					{
						name = "Sessions",
						tele_func = function()
							extensions.persisted.persisted()
						end,
					},
					{
						name = "Projects",
						tele_func = function()
							extensions.projects.projects({})
						end,
					},
					{
						name = "Zoxide",
						tele_func = function()
							extensions.zoxide.list()
						end,
					},
				},
			},
			-- Miscellaneous
			misc = {
				initial_tab = 1,
				tabs = {
					{
						name = "Colorschemes",
						tele_func = function()
							builtin.colorscheme({ enable_preview = true })
						end,
					},
					{
						name = "Notify",
						tele_func = function()
							extensions.notify.notify()
						end,
					},
					{
						name = "Undo History",
						tele_func = function()
							extensions.undo.undo()
						end,
					},
				},
			},
		},
	})
end
