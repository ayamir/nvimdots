local lang = {}

lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	opts = require("lang.vim-go").opts,
	config = require("lang.vim-go").config,
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	opts = require("lang.rust-tools").opts,
	config = require("lang.rust-tools").opts,
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	opts = require("lang.crates").opts,
	config = require("lang.crates").config,
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}
return lang