-- https://github.com/hrsh7th/vscode-langservers-extracted
return {
	-- `html-languageserver` is the deprecated bin name; both Mason and current
	-- distro packages ship `vscode-html-language-server`, which is also what the
	-- resolver's $PATH probe must look for on Mason-less setups.
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
	},
	flags = { debounce_text_changes = 500 },
	single_file_support = true,
	settings = {},
}
