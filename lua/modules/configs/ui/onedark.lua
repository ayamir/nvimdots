return function()
	require("onedark").setup({
		style = "darker",
		highlights = {
			MatchParen = { bg = "#727169" },
			Search = { bg = "#99D1DB", fg = "#282c34", ctermfg = 0, ctermbg = 11 },
			IncSearch = { bg = "#99D1DB", fg = "#282c34", ctermfg = 0, ctermbg = 11 },
			NeoTreeDirectoryIcon = { fg = "#8094b4" },
			NeoTreeIndentMarker = { fg = "#abb2bf" },
			NeoTreeExpander = { fg = "#abb2bf" },
			CurSearch = { bg = "#99D1DB", fg = "#282c34", ctermfg = 0, ctermbg = 11 },
			FinderPreviewSearch = { bg = "#e95678", fg = "#1f2329" },
			EndOfBuffer = { bg = "none", fg = "#1f2329" },
			LspInfoBorder = { fg = "#99a3b3" },
			SagaBorder = { bg = "none", fg = "#c8c093" },
			ColorColumn = { bg = "#323641" },
			FloatBorder = { bg = "none", fg = "#c8c093" },
			NormalFloat = { bg = "none", fg = "none" },
			Winbar = { fg = "#9095a2" },
			Conceal = { fg = "#abb2bf", bg = "#282C34" },
			VertSplit = { cterm = "bold", gui = "bold", fg = "#50585b" },
			WinSeparator = { link = "VertSplit" },
			NeoTreeWinSeparator = { link = "VertSplit" },
			rainbowcol1 = { fg = "#ffd700" },
			Identifier = { fg = "#abb2bf" },
		},
	})
end
