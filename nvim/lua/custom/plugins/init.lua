-- general plugins
return {
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
}
