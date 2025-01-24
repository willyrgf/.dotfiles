return {
	{
		'habamax/vim-godot',
		ft = 'gdscript',
		config = function()
			-- Set filetype-specific options for GDScript
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gdscript",
				callback = function()
					vim.bo.shiftwidth = 4
					vim.bo.tabstop = 4
					vim.bo.expandtab = true
					vim.lsp.buf.format = function() end -- Override format function for GDScript
				end,
			})

			-- GDScript formatter using gdformat
			vim.api.nvim_create_user_command("GdFormat", function()
				local gdformat_path = vim.fn.stdpath("data") ..
				    "/mason/packages/gdtoolkit/venv/bin/gdformat"
				if vim.fn.executable(gdformat_path) == 1 then
					local file = vim.api.nvim_buf_get_name(0)
					local result = vim.fn.system({ gdformat_path, file })
					if vim.v.shell_error == 0 then
						vim.notify("GDScript formatted successfully!", vim.log.levels.INFO)
						vim.cmd("edit!") -- Reload buffer to reflect changes
					else
						vim.notify("Error formatting GDScript: " .. result, vim.log.levels.ERROR)
					end
				else
					vim.notify("gdformat not found! Please install it via Mason.",
						vim.log.levels.WARN)
				end
			end, { desc = "Format the current GDScript file" })

			vim.api.nvim_create_user_command("RunGodot", function(args)
				local executable = vim.g.godot_executable or "godot"
				if vim.fn.executable(executable) == 1 then
					local scene = args.args or "project.godot"

					-- Notify the user that Godot is starting
					vim.notify("Running Godot with scene: " .. scene, vim.log.levels.INFO)

					-- Create a buffer for logs
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

					-- Open the floating window
					local win = vim.api.nvim_open_win(buf, true, {
						relative = "editor",
						width = math.floor(vim.o.columns * 0.8),
						height = math.floor(vim.o.lines * 0.4),
						col = math.floor(vim.o.columns * 0.1),
						row = math.floor(vim.o.lines * 0.3),
						style = "minimal",
						border = "rounded",
					})

					-- Start the Godot process
					vim.fn.jobstart({ executable, scene }, {
						stdout_buffered = false,
						stderr_buffered = false,
						on_stdout = function(_, data)
							if data then
								vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
								vim.api.nvim_win_set_cursor(win,
									{ #vim.api.nvim_buf_get_lines(buf, 0, -1, false), 0 }) -- Auto-scroll
							end
						end,
						on_stderr = function(_, data)
							if data then
								vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
								vim.api.nvim_win_set_cursor(win,
									{ #vim.api.nvim_buf_get_lines(buf, 0, -1, false), 0 }) -- Auto-scroll
							end
						end,
						on_exit = function(_, code)
							if code == 0 then
								vim.api.nvim_buf_set_lines(buf, -1, -1, false,
									{ "[INFO] Godot ran successfully." })
							else
								vim.api.nvim_buf_set_lines(buf, -1, -1, false,
									{ "[ERROR] Godot exited with code: " .. code })
							end
							vim.api.nvim_win_set_cursor(win,
								{ #vim.api.nvim_buf_get_lines(buf, 0, -1, false), 0 }) -- Final scroll
						end,
					})
				else
					vim.notify("Godot executable not found! Set g:godot_executable.",
						vim.log.levels.ERROR)
				end
			end, { nargs = "?", desc = "Run Godot with an optional scene file and stream logs" })

			-- Keybindings for GDScript
			vim.keymap.set('n', '<leader>rf', ':GdFormat<CR>',
				{ noremap = true, silent = true, desc = "[R]un [F]ormat" })
			vim.keymap.set('n', '<leader>rt', ':RunGodot<CR>',
				{ noremap = true, silent = true, desc = "[R]un [T]his" })

			-- Auto-format on save by calling GdFormat
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.gd",
				callback = function()
					vim.cmd("GdFormat")
				end,
			})
		end,
	},
}
