return {
	{
		'habamax/vim-godot',
		event = 'VimEnter',
		config = function()
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


			vim.keymap.set('n', '<leader>rt', ':RunGodot<CR>', {
				noremap = true,
				silent = true,
				desc = "[R]un [T]his Game",
			})
		end,
	},
}
