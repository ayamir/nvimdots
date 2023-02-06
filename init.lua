if not vim.g.vscode then
	require("core")

	-- Release note
	vim.schedule(function()
		vim.notify_once(
			[[
We've released version v2.0.0!
This is a backward-incompatible release. See the release notes for instructions on how to migrate your configs.

Visit https://github.com/ayamir/nvimdots/releases to see the release notes.

To silence this message, remove it from `init.lua` at root directory!
]],
			vim.log.levels.WARN
		)
	end)
end
