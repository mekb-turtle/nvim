return function()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	dashboard.section.header.val = {
		[[						  ._		   ]],
		[[	/\__   ____	 ______	 _|_\  _____   ]],
		[[ /	\_/ __ \/ _ \  \/ /	 |/		\  ]],
		[[|	  |	 \	___( <_> )	 /|	 |	Y Y	 \ ]],
		[[|___|	 /\___	>___/ \_/ |__|__|_|	 / ]],
		[[	   \/	  \/					\/ ]],
	}
	dashboard.section.header.opts.hl = "Type"

	local function button(sc, txt, leader_txt, keybind, keybind_opts)
		local sc_after = sc:gsub("%s", ""):gsub(leader_txt, "<leader>")

		local opts = {
			position = "center",
			shortcut = sc,
			cursor = 5,
			width = 50,
			align_shortcut = "right",
			hl_shortcut = "Keyword",
		}

		if nil == keybind then
			keybind = sc_after
		end
		keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_after, keybind, keybind_opts }

		local function on_press()
			-- local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
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
	dashboard.section.buttons.val = {
		button("space f h", " File history", leader, nil, {
			noremap = true,
			silent = true,
			nowait = true,
			callback = function()
				require("telescope.builtin").oldfiles()
			end,
		}),
		button("C-T", " File new", leader, nil, {
			noremap = true,
			silent = true,
			nowait = true,
			callback = function()
				vim.api.nvim_command("enew")
			end,
		}),
		button("space f r", " Find project", leader, nil, {
			noremap = true,
			silent = true,
			nowait = true,
			callback = function()
				require("telescope").extensions.projects.projects({})
			end,
		}),
	}
	dashboard.section.buttons.opts.hl = "String"

	function footer()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 10 + 0.5) / 10)
		return "Neovim"
			.. "   v"
			.. vim.version().major
			.. "."
			.. vim.version().minor
			.. "."
			.. vim.version().patch
			.. "   "
			.. stats.count
			.. " plugins in "
			.. ms
			.. "ms"
	end

	dashboard.section.footer.val = footer()
	dashboard.section.footer.opts.hl = "Function"

	local head_butt_padding = 2
	local occu_height = #dashboard.section.header.val + 2 * #dashboard.section.buttons.val + head_butt_padding
	local header_padding = math.max(0, math.ceil((vim.fn.winheight("$") - occu_height) * 0.25))
	local foot_butt_padding = 1

	dashboard.config.layout = {
		{ type = "padding", val = header_padding },
		dashboard.section.header,
		{ type = "padding", val = head_butt_padding },
		dashboard.section.buttons,
		{ type = "padding", val = foot_butt_padding },
		dashboard.section.footer,
	}

	alpha.setup(dashboard.opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			dashboard.section.footer.val = footer()
			pcall(vim.cmd.AlphaRedraw)
		end,
	})
end
