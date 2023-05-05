if not vim.g.vscode then
	require("core")

	-- Release note
	vim.schedule(function()
		vim.notify_once(
			[[
We've released version v3.0.0!
Visit https://github.com/ayamir/nvimdots/releases to see the release notes.
If you have icons that can't be rendered correctly (e.g., 𑨩  or � ), be sure to read this!

To silence this message, remove it from `init.lua` at the config's root directory.
]],
			vim.log.levels.WARN
		)
	end)
end
