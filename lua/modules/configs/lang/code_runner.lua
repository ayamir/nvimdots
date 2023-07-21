return function()
	require("code_runner").setup({
		mode = "term",
        focus = true,
		filetype = {
			python = "python3 -u",
			typescript = "deno run",
			rust = {
				"cd $dir &&",
				"rustc $fileName &&",
				"$dir/$fileNameWithoutExt",
			},
		},
	})
end
