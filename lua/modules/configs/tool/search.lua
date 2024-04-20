return function()
	local builtin = require("telescope.builtin")
	local extensions = require("telescope").extensions
	require("search").setup({
		collections = {
			file = {
				initial_tab = 1,
				tabs = {
					{
						name = "Files",
						tele_func = function(opts)
							opts = opts or {}
							if vim.fn.isdirectory(".git") == 1 then
								builtin.git_files(opts)
							else
								builtin.find_files(opts)
							end
						end,
					},
					{
						name = "Frecency",
						tele_func = function()
							extensions.frecency.frecency()
						end,
					},
					{
						name = "Oldfiles",
						tele_func = function()
							builtin.oldfiles()
						end,
					},
				},
			},
			git = {
				initial_tab = 4,
				tabs = {
					{
						name = "Commits",
						tele_func = function()
							builtin.git_commits()
						end,
					},
					{
						name = "Commits on File",
						tele_func = function()
							extensions.advanced_git_search.diff_commit_file()
						end,
					},
					{
						name = "Commit Content",
						tele_func = function()
							extensions.advanced_git_search.search_log_content()
						end,
					},
					{
						name = "Branches",
						tele_func = function()
							builtin.git_branches()
						end,
					},
				},
			},
			workspace = {
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
		},
	})
end
