-- general plugins
return {
	-- a neovim lib for async
	{ "nvim-neotest/nvim-nio" },

	-- multi cursors plugin
	{ 'mg979/vim-visual-multi' },

	-- undo tree to lookup history
	{ 'mbbill/undotree' },

	-- comments
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
		keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
		event = "User FileOpened",
		enabled = true
	},

	-- blame on line
	{ "lewis6991/gitsigns.nvim" },

	-- todo comments highlight
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
