return function()
	require("modules.utils").load_plugin("render-markdown", {
		-- Whether Markdown should be rendered by default or not
		enabled = true,
		-- Maximum file size (in MB) that this plugin will attempt to render
		-- Any file larger than this will effectively be ignored
		max_file_size = 2.0,
		-- Milliseconds that must pass before updating marks, updates occur
		-- within the context of the visible window, not the entire buffer
		debounce = 100,
		-- Vim modes that will show a rendered view of the markdown file
		-- All other modes will be uneffected by this plugin
		render_modes = { "n", "c", "t" },
		-- This enables hiding any added text on the line the cursor is on
		-- This does have a performance penalty as we must listen to the 'CursorMoved' event
		anti_conceal = { enabled = true },
		-- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'
		-- Only intended to be used for plugin development / debugging
		log_level = "error",
	})
end
