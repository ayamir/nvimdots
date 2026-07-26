local M = {}

local function commit_actions(bufnr)
	local actions = require("advanced_git_search.snacks.actions")

	return {
		actions = {
			open_commit_in_browser = actions.open_commit_in_browser.action,
			copy_commit_hash = actions.copy_commit_hash.action,
			show_entire_commit = actions.show_entire_commit.action,
			confirm = actions.open_diff_buffer_with_selected_commit(bufnr).action,
		},
		win = {
			input = {
				keys = {
					[actions.open_commit_in_browser.key] = {
						"open_commit_in_browser",
						mode = { "n", "i" },
					},
					[actions.copy_commit_hash.key] = {
						"copy_commit_hash",
						mode = { "n", "i" },
					},
					[actions.show_entire_commit.key] = {
						"show_entire_commit",
						mode = { "n", "i" },
					},
				},
			},
		},
	}
end

function M.search_log_content(opts)
	local finders = require("advanced_git_search.snacks.finders")
	local formatters = require("advanced_git_search.snacks.formatters")
	local previewers = require("advanced_git_search.snacks.previewers")
	local actions = commit_actions(vim.fn.bufnr())

	return require("snacks").picker.pick(vim.tbl_deep_extend("force", {
		title = "Commit content",
		finder = finders.git_log_content(),
		format = formatters.git_log(),
		preview = previewers.git_diff_content(),
		live = true,
		actions = actions.actions,
		win = actions.win,
	}, opts or {}))
end

function M.diff_commit_file(opts)
	local bufnr = vim.fn.bufnr()
	local finders = require("advanced_git_search.snacks.finders")
	local formatters = require("advanced_git_search.snacks.formatters")
	local previewers = require("advanced_git_search.snacks.previewers")
	local actions = commit_actions(bufnr)

	return require("snacks").picker.pick(vim.tbl_deep_extend("force", {
		title = "Diff current file",
		finder = finders.git_log_file(bufnr),
		format = formatters.git_log(),
		preview = previewers.git_diff_file({ bufnr = bufnr }),
		live = true,
		actions = actions.actions,
		win = actions.win,
	}, opts or {}))
end

return M
