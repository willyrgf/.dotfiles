return {
	{
		'habamax/vim-godot',
		event = 'VimEnter',
		config = function()
			-- Create custom command to run godot
			vim.api.nvim_create_user_command("RunGodot", function(args)
				local godot_executable = vim.g.godot_executable or "godot"
				if not vim.fn.executable(godot_executable) then
					vim.notify("Godot executable not found! Please set g:godot_executable.",
						vim.log.levels.ERROR)
					return
				end

				local scene = args.args or "project.godot" -- Default to project.godot
				local command = godot_executable .. " " .. scene

				vim.notify("Running Godot: " .. scene, vim.log.levels.INFO)
				vim.fn.jobstart(command, {
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("Godot ran successfully.", vim.log.levels.INFO)
						else
							vim.notify("Godot failed to run. Exit code: " .. code,
								vim.log.levels.ERROR)
						end
					end,
				})
			end, { nargs = "?", desc = "Run Godot with an optional scene file" })

			vim.keymap.set('n', '<leader>rt', ':RunGodot<CR>', {
				noremap = true,
				silent = true,
				desc = "[R]un [T]his Game",
			})
		end,
	},
}
