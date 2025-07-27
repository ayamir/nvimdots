-- https://github.com/vscode-langservers/vscode-html-languageserver-bin
return {
	cmd = { "html-languageserver", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
	},
	flags = { debounce_text_changes = 500 },
	single_file_support = true,
	settings = {},
}
