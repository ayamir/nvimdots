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
		project = {
			["~/Github/pytorch-cpp"] = {
				name = "Learn libtorch",
				description = "Project with libtorch",
				file_name = "$fileName",
				command = "g++ -I/usr/local/libtorch/include "
					.. "-I/usr/local/libtorch/include/torch/csrc/api/include "
					.. "-L/usr/local/libtorch/lib "
					.. "-o $fileNameWithoutExt $fileName "
					.. "-ltorch -lc10 -ltorch_cpu -ltorch_global_deps -ltorch_python -lc10_cuda -ltorch_cuda"
					.. "&& ./$fileNameWithoutExt",
			},
		},
	})
end
