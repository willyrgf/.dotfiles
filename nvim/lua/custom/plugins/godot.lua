return {
	{
		'habamax/vim-godot',
		event = 'VimEnter',
		config = function()
			-- Filetype-specific settings for GDScript
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gdscript",
				callback = function()
					vim.bo.shiftwidth = 4 -- Number of spaces for autoindent
					vim.bo.tabstop = 4 -- Number of spaces per tab
					vim.bo.expandtab = true -- Use spaces instead of tabs
				end,
			})

			-- Auto-indent on save, preserving cursor position
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.gd",
				callback = function()
					-- Save the current cursor position
					local cursor_position = vim.api.nvim_win_get_cursor(0)
					-- Perform the auto-indentation
					vim.cmd("normal gg=G")
					-- Restore the cursor position
					vim.api.nvim_win_set_cursor(0, cursor_position)
				end,
			})

			-- Define the path to gdformat (adjust if needed)
			local gdformat_path = vim.fn.stdpath("data") .. "/mason/packages/gdtoolkit/venv/bin/gdformat"

			-- GdFormat command
			vim.api.nvim_create_user_command("GdFormat", function()
				if not gdformat_path or vim.fn.executable(gdformat_path) ~= 1 then
					vim.notify(
						"gdformat not found at " ..
						gdformat_path .. "! Please check your configuration.",
						vim.log.levels.ERROR)
					return
				end

				local file = vim.api.nvim_buf_get_name(0) -- Get the current file path
				local result = vim.fn.system({ gdformat_path, file })
				if vim.v.shell_error == 0 then
					vim.notify("GDScript formatted successfully!", vim.log.levels.INFO)
					-- Reload the buffer to reflect changes
					vim.cmd("edit")
				else
					vim.notify("Error formatting GDScript: " .. result, vim.log.levels.ERROR)
				end
			end, {
				desc = "Format the current GDScript file using gdformat",
			})

			-- Run Godot command
			vim.api.nvim_create_user_command("RunGodot", function(args)
				local godot_executable = vim.g.godot_executable or "godot"
				if not vim.fn.executable(godot_executable) then
					vim.notify("Godot executable not found! Please set g:godot_executable.",
						vim.log.levels.ERROR)
					return
				end

				local scene = args.args or "project.godot" -- Default to project.godot
				local command = { godot_executable, scene }

				-- Create a new buffer for logs
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
				vim.api.nvim_buf_set_name(buf, "Godot Logs")

				-- Open the buffer in a floating window
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = math.floor(vim.o.columns * 0.8),
					height = math.floor(vim.o.lines * 0.4),
					col = math.floor(vim.o.columns * 0.1),
					row = math.floor(vim.o.lines * 0.3),
					style = "minimal",
					border = "rounded",
				})

				-- Notify the user that Godot is starting
				vim.notify("Running Godot: " .. scene, vim.log.levels.INFO)

				-- Start the Godot process
				vim.fn.jobstart(command, {
					stdout_buffered = false,
					stderr_buffered = false,
					on_stdout = function(_, data)
						if data then
							vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
						end
					end,
					on_stderr = function(_, data)
						if data then
							vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
						end
					end,
					on_exit = function(_, code)
						if code == 0 then
							vim.api.nvim_buf_set_lines(buf, -1, -1, false,
								{ "[INFO] Godot ran successfully." })
						else
							vim.api.nvim_buf_set_lines(buf, -1, -1, false,
								{ "[ERROR] Godot failed to run. Exit code: " .. code })
						end
						-- Keep the window open for the user to review the logs
						vim.api.nvim_set_current_win(win)
					end,
				})
			end, { nargs = "?", desc = "Run Godot with an optional scene file and show logs" })

			-- Keybinding for running Godot
			vim.keymap.set('n', '<leader>rt', ':RunGodot<CR>', {
				noremap = true,
				silent = true,
				desc = "[R]un [T]his Game",
			})
		end,
	},
}
