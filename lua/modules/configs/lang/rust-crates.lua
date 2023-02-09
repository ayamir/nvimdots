return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics", true),
		git = require("modules.utils.icons").get("git", true),
		misc = require("modules.utils.icons").get("misc", true),
		ui = require("modules.utils.icons").get("ui", true),
		kind = require("modules.utils.icons").get("kind", true),
	}

	local opts = {
		smart_insert = true,
		insert_closing_quote = true,
		avoid_prerelease = true,
		autoload = true,
		autoupdate = true,
		autoupdate_throttle = 250,
		loading_indicator = true,
		date_format = "%Y-%m-%d",
		thousands_separator = ",",
		notification_title = "Crates",
		curl_args = { "-sL", "--retry", "1" },
		disable_invalid_feature_diagnostic = false,
		text = {
			loading = " " .. icons.misc.Watch .. "Loading",
			version = " " .. icons.ui.Check .. "%s",
			prerelease = " " .. icons.diagnostics.Warning_alt .. "%s",
			yanked = " " .. icons.diagnostics.Error .. "%s",
			nomatch = " " .. icons.diagnostics.Question .. "No match",
			upgrade = " " .. icons.diagnostics.Hint_alt .. "%s",
			error = " " .. icons.diagnostics.Error .. "Error fetching crate",
		},
		popup = {
			autofocus = false,
			hide_on_select = true,
			copy_register = '"',
			style = "minimal",
			border = "rounded",
			show_version_date = true,
			show_dependency_version = true,
			max_height = 30,
			min_width = 20,
			padding = 1,
			text = {
				title = icons.ui.Package .. "%s",
				description = "%s",
				created_label = icons.misc.Added .. "created" .. "        ",
				created = "%s",
				updated_label = icons.misc.ManUp .. "updated" .. "        ",
				updated = "%s",
				downloads_label = icons.ui.CloudDownload .. "downloads      ",
				downloads = "%s",
				homepage_label = icons.misc.Campass .. "homepage       ",
				homepage = "%s",
				repository_label = icons.git.Repo .. "repository     ",
				repository = "%s",
				documentation_label = icons.diagnostics.Information_alt .. "documentation  ",
				documentation = "%s",
				crates_io_label = icons.ui.Package .. "crates.io      ",
				crates_io = "%s",
				categories_label = icons.kind.Class .. "categories     ",
				keywords_label = icons.kind.Keyword .. "keywords       ",
				version = "  %s",
				prerelease = icons.diagnostics.Warning_alt .. "%s prerelease",
				yanked = icons.diagnostics.Error .. "%s yanked",
				version_date = "  %s",
				feature = "  %s",
				enabled = icons.ui.Play .. "%s",
				transitive = icons.ui.List .. "%s",
				normal_dependencies_title = icons.kind.Interface .. "Dependencies",
				build_dependencies_title = icons.misc.Gavel .. "Build dependencies",
				dev_dependencies_title = icons.misc.Glass .. "Dev dependencies",
				dependency = "  %s",
				optional = icons.ui.BigUnfilledCircle .. "%s",
				dependency_version = "  %s",
				loading = " " .. icons.misc.Watch,
			},
		},
		src = {
			insert_closing_quote = true,
			text = {
				prerelease = " " .. icons.diagnostics.Warning_alt .. "pre-release ",
				yanked = " " .. icons.diagnostics.Error_alt .. "yanked ",
			},
		},
	}

	-- custom key map setup
	vim.keymap.set("n", "<leader>ct", function()
		require("crates").toggle()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cr", function()
		require("crates").reload()
	end, { buffer = true })

	vim.keymap.set("n", "<leader>cp", function()
		require("crates").show_popup()
	end, { buffer = true })
	vim.keymap.set("n", "K", function()
		require("crates").show_popup()
	end, { buffer = true })

	vim.keymap.set("n", "<leader>cv", function()
		require("crates").show_versions_popup()
		require("crates").show_popup()
	end, { buffer = true })
	vim.keymap.set("n", "ga", function()
		require("crates").show_versions_popup()
		require("crates").show_popup()
	end, { buffer = true })

	vim.keymap.set("n", "gf", function()
		require("crates").show_features_popup()
		require("crates").show_popup()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cf", function()
		require("crates").show_features_popup()
		require("crates").show_popup()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cd", function()
		require("crates").show_dependencies_popup()
		require("crates").show_popup()
	end, { buffer = true })

	vim.keymap.set("n", "<leader>cu", function()
		require("crates").update_crate()
	end, { buffer = true })
	vim.keymap.set("v", "<leader>cu", function()
		require("crates").update_crates()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>ca", function()
		require("crates").update_all_crates()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cU", function()
		require("crates").upgrade_crate()
	end, { buffer = true })
	vim.keymap.set("v", "<leader>cU", function()
		require("crates").upgrade_crates()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cA", function()
		require("crates").upgrade_all_crates()
	end, { buffer = true })

	vim.keymap.set("n", "<leader>cH", function()
		require("crates").open_homepage()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cR", function()
		require("crates").open_repository()
	end, { buffer = true })
	vim.keymap.set("n", "gD", function()
		require("crates").open_documentation()
	end, { buffer = true })
	vim.keymap.set("n", "<leader>cC", function()
		require("crates").open_crates_io()
	end, { buffer = true })

	require("crates").setup(opts)
end
