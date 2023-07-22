local M = {}

local function removeFromTable(t, valueToRemove)
	local indexToRemove = nil
    if #t == 0 then
        t[valueToRemove] = nil
    else
        for i, v in ipairs(t) do
            if v == valueToRemove then
                indexToRemove = i
                break
            end
        end
        if indexToRemove then
            table.remove(t, indexToRemove)
        end
    end

    return t
end

M["merge"] = function(x, y)
	for k, v in pairs(y) do
		if type(v) == "table" then
			if type(x[k] or false) == "table" then
				M.merge(x[k] or {}, y[k] or {})
			else
				x[k] = v
			end
		else
			x[k] = v
		end
	end
	return x
end

M["reset"] = function(x, y)
	for k, v in pairs(y) do
        x = removeFromTable(x, v)
	end
	return x
end

return M