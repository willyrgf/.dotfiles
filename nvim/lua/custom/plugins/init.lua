-- general plugins
return {
	--multi cursors plugin --
	{ 'mg979/vim-visual-multi' },

	-- undo tree to lookup history
	{ 'mbbill/undotree' },

	-- Comments
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
		keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
		event = "User FileOpened",
		enabled = true
	},

	-- Blame on line
	{ "lewis6991/gitsigns.nvim" },

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	}
}
