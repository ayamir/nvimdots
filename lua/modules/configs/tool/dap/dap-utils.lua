local M = {}

function M.path_to_program()
	return vim.fn.input("Path to program: ", vim.fn.expand("%:p:r"), "file")
end

function M.get_env()
	local variables = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(variables, string.format("%s=%s", k, v))
	end
	return variables
end

function M.input_args()
	local input = vim.fn.input("Input args: ")
	return vim.fn.split(input, " ", true)
end

return M
