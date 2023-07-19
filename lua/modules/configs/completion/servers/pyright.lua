return {
	settings = {
		python = {
			analysis = {
				-- typeCheckingMode = "off",
				-- typeCheckingMode = "strict",
				diagnosticMode = "openFilesOnly",
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
				},
				argAssignmentFunction = false,
			},
			pythonPath = "python3",
		},
	},
}
