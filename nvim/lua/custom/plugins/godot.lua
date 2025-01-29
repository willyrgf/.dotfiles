return {
	{
		'habamax/vim-godot',
		ft = 'gdscript',
		config = function() -- Set filetype-specific options for GDScript
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gdscript",
				callback = function()
					vim.bo.shiftwidth = 4
					vim.bo.tabstop = 4
					vim.bo.expandtab = true
					vim.lsp.buf.format =
					-- skipping lspconfig format for gdscript
					    function(opts)
						    local filetype = vim.bo.filetype
						    if vim.bo.filetype ~= "gdscript" then
							    -- fall back to lsp formatting for other filetypes
							    vim.lsp.buf.format(opts)
						    end
					    end
				end,
			})

			local function format_gdscript()
				local gdformat_path = vim.fn.stdpath("data") ..
				    "/mason/packages/gdtoolkit/venv/bin/gdformat"
				if vim.fn.executable(gdformat_path) == 1 then
					local buf = vim.api.nvim_get_current_buf()
					local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

					-- Check if buffer is empty
					if #content == 0 then
						vim.notify("Buffer is empty, skipping formatting.", vim.log.levels.INFO)
						return
					end

					-- Run gdformat directly on the buffer content
					local temp_file = vim.fn.tempname()
					vim.fn.writefile(content, temp_file)
					local result = vim.fn.system({ gdformat_path, temp_file })

					if vim.v.shell_error == 0 then
						-- Read back formatted content
						local formatted_content = vim.fn.readfile(temp_file)

						-- Ensure buffer is modifiable before setting lines
						vim.api.nvim_buf_set_option(buf, "modifiable", true)
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_content)
						vim.notify("GDScript formatted successfully!", vim.log.levels.INFO)
					else
						-- Handle formatting errors
						local error_message = table.concat(vim.split(result, "\n"), "\n")
						vim.notify("Error formatting GDScript:\n" .. error_message,
							vim.log.levels.ERROR)
					end

					-- Clean up temporary file
					vim.fn.delete(temp_file)
				else
					vim.notify("gdformat not found! Please install it via Mason.",
						vim.log.levels.WARN)
				end
			end
			vim.api.nvim_create_user_command("GdFormat", format_gdscript,
				{ desc = "Format the current GDScript file" })

			-- Auto-format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.gd",
				callback = function()
					format_gdscript()
				end,
			})

			vim.api.nvim_create_user_command("RunGodot", function(args)
				local executable = vim.g.godot_executable or "godot"
				if vim.fn.executable(executable) == 1 then
					local scene = args.args or "project.godot"

					-- Create a buffer for logs
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

					-- Add close window keybinding
					vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {
						noremap = true,
						silent = true,
						nowait = true,
						desc = "Close Godot log window"
					})

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
									{ "[INFO] Godot exited successfully. Press 'q' to close." })
							else
								vim.api.nvim_buf_set_lines(buf, -1, -1, false,
									{ "[ERROR] Godot exited with code: " ..
									code .. ". Press 'q' to close." })
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
		end,
	},
}
