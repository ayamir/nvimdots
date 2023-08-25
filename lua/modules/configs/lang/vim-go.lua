return function()
	vim.g.go_doc_keywordprg_enabled = 0
	vim.g.go_def_mapping_enabled = 0
	vim.g.go_code_completion_enabled = 0

	require("modules.utils").load_plugin("vim-go", nil, true)
end
