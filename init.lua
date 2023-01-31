if not vim.g.vscode then
	require("core")

	-- Release note
	vim.schedule(function()
		vim.notify_once(
			[[
We've released version v1.0.0!
It has brought about some major changes that would require a manual cleanup.

Visit https://github.com/ayamir/nvimdots/releases to see the release notes.

To silence this message, remove it from `init.lua` at root directory!
]],
			vim.log.levels.WARN
		)
	end)
end
