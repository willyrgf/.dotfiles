-- AI Assistant

-- Define opts logic separately for reuse
local get_avante_opts = function()
	if vim.g.avante_enabled == true then
		return {
			provider = "openai",
			openai = {
				endpoint = "https://openrouter.ai/api/v1",
				model = "google/gemini-2.5-pro-exp-03-25:free",
				timeout = 30000,
				temperature = 0.3,
			},
		}
	end
	return {} -- Return empty opts if disabled
end

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	-- Conditionally load the plugin based on g:avante_enabled
	cond = function()
		return vim.g.avante_enabled ~= false -- Load plugin only if g:avante_enabled is not false
	end,
	opts = get_avante_opts, -- Use the separate function
	build = "make BUILD_FROM_SOURCE=true",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.pick",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function(_, opts)
		-- Set default state for avante_enabled (disabled by default)
		vim.g.avante_enabled = vim.g.avante_enabled or false
		if vim.g.avante_enabled then
			require("avante").setup(opts)
		end

		-- Define a toggle command
		vim.api.nvim_create_user_command("AvanteToggle", function()
			vim.g.avante_enabled = not vim.g.avante_enabled
			if vim.g.avante_enabled then
				-- Enable: Load and setup the plugin
				require("lazy").load({ plugins = { "avante.nvim" } })
				-- Explicitly call setup after loading
				require("avante").setup(get_avante_opts())
				vim.notify("Avante enabled", vim.log.levels.INFO)
			else
				-- Disable: Unload or reset plugin (optional)
				-- Note: Lazy.nvim doesn't fully support unloading, so you may need to restart Neovim
				-- Alternatively, you can clear Avante's internal state if supported
				if package.loaded["avante"] then
					package.loaded["avante"] = nil
				end
				vim.notify("Avante disabled (restart Neovim to fully unload)", vim.log.levels.INFO)
			end
		end, { desc = "Toggle Avante.nvim on/off" })

		vim.keymap.set("n", "<leader>ta", ":AvanteToggle<CR>", { desc = "[T]oggle [A]vante.nvim" })
	end,
}
