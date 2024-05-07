return {
	cmd = { "delance-langserver", "--stdio" },
	-- filetypes = { "python" },
	settings = {
		pylance = {
			disableOrganizeImports = true,
			disableTaggedHints = true,
		},
		python = {
			pythonPath = vim.fn.exepath("python"),
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace", -- openFilesOnly, workspace
				typeCheckingMode = "basic", -- off, basic, strict
				useLibraryCodeForTypes = true,
				extraPaths = {
					"src",
				},
				diagnosticSeverityOverrides = {
					reportGeneralTypeIssues = "none",
					reportUnboundVariable = false,
					strictParameterNoneValue = false,
				},
				stubPath = vim.fn.stdpath("data") .. "/site/lazy/python-type-stubs",
				inlayHints = {
					functionReturnTypes = true,
					pytestParameters = true,
					variableTypes = true,
					callArgumentNames = "partial",
				},
			},
		},
	},
	single_file_support = true,
}
