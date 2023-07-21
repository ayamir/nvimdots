local function merge(x, y)
	for k, v in pairs(y) do
		if type(v) == "table" then
			if type(x[k] or false) == "table" then
				merge(x[k] or {}, y[k] or {})
			else
				x[k] = v
			end
		else
			x[k] = v
		end
	end
	return x
end

return merge