return {
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		opts = {
			size = 20,
			open_mapping = [[<c-t>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			highlights = {
				FloatBorder = {
					guifg = "#3c3836", -- https://github.com/sainnhe/gruvbox-material/blob/3fff63b0d6a425ad1076a260cd4f6da61d1632b1/autoload/gruvbox_material.vim#LL44C37-L44C44
					--guifg = "#282828",
				},
			},
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		}
	}

}
