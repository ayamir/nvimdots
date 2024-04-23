--- self Latex snippets

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local M = {}

local MATH_NODES = {
	displayed_equation = true,
	inline_formula = true,
	math_environment = true,
}

local TEXT_NODES = {
	text_mode = true,
	label_definition = true,
	label_reference = true,
}

local function get_node_at_cursor()
	local pos = vim.api.nvim_win_get_cursor(0)
	-- Subtract one to account for 1-based row indexing in nvim_win_get_cursor
	local row, col = pos[1] - 1, pos[2]

	local parser = vim.treesitter.get_parser(0, "latex")
	if not parser then
		return
	end

	local root_tree = parser:parse({ row, col, row, col })[1]
	local root = root_tree and root_tree:root()
	if not root then
		return
	end

	return root:named_descendant_for_range(row, col, row, col)
end

function M.in_text(check_parent)
	local node = get_node_at_cursor()
	while node do
		if node:type() == "text_mode" then
			if check_parent then
				-- For \text{}
				local parent = node:parent()
				if parent and MATH_NODES[parent:type()] then
					return false
				end
			end

			return true
		elseif MATH_NODES[node:type()] then
			return false
		end
		node = node:parent()
	end
	return true
end

function M.in_mathzone()
	local node = get_node_at_cursor()
	while node do
		if TEXT_NODES[node:type()] then
			return false
		elseif MATH_NODES[node:type()] then
			return true
		end
		node = node:parent()
	end
	return false
end

local snips, autosnips = {}, {}

snips = {
	s(
		{ trig = "it", name = "italic", dscr = "Insert italic text." },
		{ t("\\textit{"), i(1), t("}") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
	s(
		{ trig = "em", name = "emphasize", dscr = "Insert emphasize text." },
		{ t("\\emph{"), i(1), t("}") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
}

autosnips = {
	s({
		trig = "([a-zA-Z])bf",
		name = "math bold",
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snip)
			return "\\mathbf{" .. snip.captures[1] .. "}"
		end, {}),
	}, { condition = M.in_mathzone }),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\textbf{"), i(1), t("}") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\mathbf{"), i(1), t("}") },
		{ condition = M.in_mathzone, show_condition = M.in_text }
	),
}

return snips, autosnips
