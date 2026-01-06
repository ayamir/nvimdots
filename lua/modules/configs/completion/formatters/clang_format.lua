local project_root = vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()

-- check if ".clang-format" config exists, if it does, use the config instead of default
if not vim.uv.fs_stat(vim.fs.joinpath(project_root, ".clang-format")) then
	return { "-style={ BasedOnStyle: LLVM, IndentWidth: 4 }" }
end
return {}
