return {
	--- style
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		enabled = true,
		priority = 100,
		config = function()
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},

	--- overrides
	-- treesitter
	{
		"nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"gdscript",
				"godot_resource",
				"gdshader",
			})

			opts.incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					node_decremental = "<BS>",
					scope_incremental = "<TAB>",
				},
			}

			return opts
		end,
	},

	--- utilities
	-- terminal as an popup window ctrl+t
	{
		"akinsho/toggleterm.nvim",
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
				},
			},
		},
	},
}
