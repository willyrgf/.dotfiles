return {
	{
		'sainnhe/gruvbox-material',
		lazy = false,
		enabled = true,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "original"
			-- vim.g.gruvbox_material_transparent_background = 1
			vim.cmd.colorscheme 'gruvbox-material'
		end,
	},
	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		lazy = false,
		enabled = true,
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = 'gruvbox-material',
				component_separators = '|',
				section_separators = '',
			},
		},
	},


}
