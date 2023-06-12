local M = {}

function M.input_args()
	return function()
		local argument_string = vim.fn.input("Program arg(s) (enter nothing to leave it null): ")
		return vim.fn.split(argument_string, " ", true)
	end
end

function M.input_exec_path()
	return function()
		return vim.fn.input('Path to executable (default to "progout"): ', vim.fn.getcwd() .. "/progout", "file")
	end
end

function M.get_env()
	return function()
		local variables = {}
		for k, v in pairs(vim.fn.environ()) do
			table.insert(variables, string.format("%s=%s", k, v))
		end
		return variables
	end
end

return M
