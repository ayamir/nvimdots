local function readAll(file)
	local f = assert(io.open(file, "rb"))
	local content = f:read("*all")
	f:close()
	return content
end

local token_ok, token = pcall(readAll, vim.fn.expand("~") .. "/.config/sourcery/tokenizer.txt")

if not token_ok then
	return {}
end

token = string.gsub(token, "\n", "")
return {
	init_options = {
		token = token,
	},
}
