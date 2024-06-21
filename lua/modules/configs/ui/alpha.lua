return function()
	local dashboard = require("alpha.themes.dashboard")
	require("modules.utils").gen_alpha_hl()

	dashboard.section.header.val = require("core.settings").dashboard_image
	dashboard.section.header.opts.hl = "AlphaHeader"

	local function button(sc, txt, leader_txt, keybind, keybind_opts)
		local sc_after = sc:gsub("%s", ""):gsub(leader_txt, "<leader>")

		local opts = {
			position = "center",
			shortcut = sc,
			cursor = 5,
			width = 50,
			align_shortcut = "right",
			hl = "AlphaButtons",
			hl_shortcut = "AlphaShortcut",
		}

		if nil == keybind then
			keybind = sc_after
		end
		keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_after, keybind, keybind_opts }

		local function on_press()
			-- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
			local key = vim.api.nvim_replace_termcodes(sc_after .. "<Ignore>", true, false, true)
			vim.api.nvim_feedkeys(key, "t", false)
		end

		return {
			type = "button",
			val = txt,
			on_press = on_press,
			opts = opts,
		}
	end

	local leader = " "
	local icons = {
		documents = require("modules.utils.icons").get("documents", true),
		git = require("modules.utils.icons").get("git", true),
		ui = require("modules.utils.icons").get("ui", true),
		misc = require("modules.utils.icons").get("misc", true),
	}

	dashboard.section.buttons.val = {
		button(
			"space f c",
			icons.misc.Neovim .. "Telescope collections",
			leader,
			nil,
			{ noremap = true, silent = true, nowait = true }
		),
		button(
			"space f f",
			icons.documents.FileFind .. "Find files",
			leader,
			nil,
			{ noremap = true, silent = true, nowait = true }
		),
		button(
			"space f d",
			icons.ui.FolderWithHeart .. "Retrieve dossiers",
			leader,
			nil,
			{ noremap = true, silent = true, nowait = true }
		),
		button(
			"space f p",
			icons.documents.Word .. "Find patterns",
			leader,
			nil,
			{ noremap = true, silent = true, nowait = true }
		),
		button(
			"space f g",
			icons.git.Git .. "Locate Git objects",
			leader,
			nil,
			{ noremap = true, silent = true, nowait = true }
		),
		button(
			"space f m",
			icons.misc.Ghost .. "Miscellaneous artifacts",
			leader,
			nil,
			{ noremap = true, silent = true, nowait = true }
		),
	}
	dashboard.section.buttons.opts.hl = "AlphaButtons"

	local function footer()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		return "   Have Fun with neovim"
			.. "  󰀨 v"
			.. vim.version().major
			.. "."
			.. vim.version().minor
			.. "."
			.. vim.version().patch
			.. "  󰂖 "
			.. stats.count
			.. " plugins in "
			.. ms
			.. "ms"
	end

	dashboard.section.footer.val = footer()
	dashboard.section.footer.opts.hl = "AlphaFooter"

	local head_butt_padding = 2
	local occu_height = #dashboard.section.header.val + 2 * #dashboard.section.buttons.val + head_butt_padding
	local header_padding = math.max(0, math.ceil((vim.fn.winheight(0) - occu_height) * 0.25))
	local foot_butt_padding = 1

	dashboard.config.layout = {
		{ type = "padding", val = header_padding },
		dashboard.section.header,
		{ type = "padding", val = head_butt_padding },
		dashboard.section.buttons,
		{ type = "padding", val = foot_butt_padding },
		dashboard.section.footer,
	}

	require("modules.utils").load_plugin("alpha", dashboard.opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			dashboard.section.footer.val = footer()
			pcall(vim.cmd.AlphaRedraw)
		end,
	})
end
